#!/usr/bin/env bash

set -euo pipefail

cp -f ./realm_vm.sh ./rme-stack/realm_vm.sh

# virtio-9p-device:
# this shares the current directory with the host, providing the files needed
# to launch the guest.

# -serial: the following parameters allow to use separate consoles for
# Firmware (port 54320), Secure payload (54321), host (54322) and guest (54323).
qemu_cmd='qemu-system-aarch64 \
-M virt,virtualization=on,secure=on,gic-version=3 \
-M acpi=off -cpu max,x-rme=on -m 8G -smp 8 \
-nographic \
-bios ./rme-stack/out/bin/flash.bin \
-kernel ./rme-stack/out/bin/Image \
-drive format=raw,if=none,file=./rme-stack/out-br/images/rootfs.ext4,id=hd0 \
-device virtio-blk-pci,drive=hd0 \
-nodefaults \
-serial tcp:localhost:54320 \
-serial tcp:localhost:54321 \
-chardev socket,mux=on,id=hvc0,port=54322,host=localhost \
-device virtio-serial-device \
-device virtconsole,chardev=hvc0 \
-chardev socket,mux=on,id=hvc1,port=54323,host=localhost \
-device virtio-serial-device \
-device virtconsole,chardev=hvc1 \
-append "root=/dev/vda console=hvc0" \
-device virtio-net-pci,netdev=net0 -netdev user,id=net0 \
-device virtio-9p-device,fsdev=shr0,mount_tag=shr0 \
-fsdev local,security_model=none,path=./rme-stack,id=shr0'

# rawer send control-c instead of killing socat
unset TMUX
tmux -L PATH \
    new-session -s rme 'echo Firmware; socat - TCP-LISTEN:54320' \; \
    split-window 'echo Secure Payload; socat - TCP-LISTEN:54321' \; \
    split-window 'echo Host; socat -,rawer TCP-LISTEN:54322' \; \
    split-window 'echo Guest; socat -,rawer TCP-LISTEN:54323' \; \
    select-layout tiled \; \
    split-window -p 20 bash -cx "$qemu_cmd || read" \; \
    select-pane -t 3
