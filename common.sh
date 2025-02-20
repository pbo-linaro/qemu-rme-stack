cca_version=4

assets_folder()
{
    board=$1
    echo rme-stack-cca-v${cca_version}-${board}
}

build_for_board()
{
    if [ -z "${DISABLE_CONTAINER_CHECK:-}" ]; then
        echo "run command using ./container.sh ./build_..."
        exit 1
    fi
    board=$1; shift
    out_files="$*"

    work=build-cca-v${cca_version}-${board}
    mkdir -p $work
    cd $work
    repo init -u https://git.codelinaro.org/linaro/dcap/op-tee-4.2.0/manifest.git \
              -b cca/v${cca_version} -m ${board}_cca.xml
    repo sync -j$(nproc) --no-clone-bundle
    cd build
    make -j$(nproc) toolchains
    # In case you want to debug edk2, you need to add EDK2_BUILD=DEBUG
    # We build TF-A and RMM in Debug, but keep the same log level than Release.
    make -j$(nproc) \
        RMM_BUILD=Debug RMM_LOG_LEVEL=40 \
        TF_A_DEBUG=1 TF_A_LOGLVL=40

    cd ../../
    out=$(assets_folder $board)
    rm -rf $out
    for o in $out_files
    do
        rsync -avL --mkpath $work/$o $out/$(dirname $o)/
    done
}

run_vm()
{
    board=$1; shift
    qemu_cmd="$*"
    out=$(assets_folder $board)

    cp -f ./realm_vm.sh $out/realm_vm.sh

    RUN_VM_TMUX_EXTRA_COMMANDS=${RUN_VM_TMUX_EXTRA_COMMANDS:-}
    # rawer send control-c instead of killing socat
    unset TMUX
    tmux -L PATH \
        new-session -s rme 'echo Firmware; socat - TCP-LISTEN:54320' \; \
        split-window 'echo Secure Payload; socat - TCP-LISTEN:54321' \; \
        split-window 'echo Host; socat -,rawer TCP-LISTEN:54322' \; \
        split-window 'echo Guest; socat -,rawer TCP-LISTEN:54323' \; \
        select-layout tiled \; \
        split-window -p 20 bash -cx "$qemu_cmd || read" \; \
        select-pane -t 3 \; \
        ${RUN_VM_TMUX_EXTRA_COMMANDS}
}
