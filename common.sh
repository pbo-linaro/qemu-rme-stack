build_board()
{
    if [ -z "${DISABLE_CONTAINER_CHECK:-}" ]; then
        echo "run command using ./container.sh ./build_..."
        exit 1
    fi
    build_folder=$1; shift
    manifest=$1; shift
    branch=$1; shift

    mkdir -p $build_folder
    pushd $build_folder
    repo init -u https://git.codelinaro.org/linaro/dcap/op-tee-4.2.0/manifest.git \
              -b ${branch} -m ${manifest}
    repo sync -j$(nproc) --no-clone-bundle
    cd build

    # add nokaslr to kernel command line, to be able to debug it.
    # Virt boots with a kernel, while sbsa boots with an image.
    # This fix only applies for sbsa.
    sed -e 's#Image root=/dev/vda console=hvc0"#Image root=/dev/vda console=hvc0 nokaslr"#' -i Makefile

    # change optimization build for tf-rmm debug build
    sed -e 's/Og/O0/' -i ../rmm/toolchains/common.cmake

    make -j$(nproc) toolchains
    # In case you want to debug edk2, you need to add EDK2_BUILD=DEBUG
    # We build TF-A and RMM in Debug, but keep the same log level than Release.
    make -j$(nproc) \
        RMM_BUILD=Debug RMM_LOG_LEVEL=40 \
        TF_A_DEBUG=1 TF_A_LOGLVL=40

    popd
}

copy_assets()
{
    build_folder=$1; shift
    assets_folder=$1; shift
    assets_files="$*"

    rm -rf $assets_folder
    for o in $assets_files
    do
        rsync -avL --mkpath $build_folder/$o $assets_folder/$(dirname $o)/
    done
}

run_vm()
{
    assets_folder=$1; shift
    qemu_cmd="$*"

    cp -f ./realm_vm.sh $assets_folder/realm_vm.sh

    RUN_VM_TMUX_EXTRA_COMMANDS=${RUN_VM_TMUX_EXTRA_COMMANDS:-}
    # rawer send control-c instead of killing socat
    # sleep 1 before qemu to let the time for socat to listen on socket
    unset TMUX
    tmux \
        new-session -s rme 'echo Firmware; socat - TCP-LISTEN:54320' \; \
        split-window 'echo Secure Payload; socat - TCP-LISTEN:54321' \; \
        split-window 'echo Host; socat -,rawer TCP-LISTEN:54322' \; \
        split-window 'echo Guest; socat -,rawer TCP-LISTEN:54323' \; \
        select-layout tiled \; \
        split-window -p 20 bash -cx "sleep 1; $qemu_cmd || read" \; \
        select-pane -t 3 \; \
        ${RUN_VM_TMUX_EXTRA_COMMANDS}
}
