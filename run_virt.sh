#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "usage: qemu_aarch64_cmd"
    exit 1
fi

qemu_aarch64_cmd=$*; shift

source ./common.sh

# virtio-9p-device:
# this shares the current directory with the host, providing the files needed
# to run the guest.
# -serial: the following parameters allow to use separate consoles for
# Firmware (port 54320), Secure payload (54321), host (54322) and guest (54323).
#
# run with nokaslr to allow debug linux kernel
assets_folder=virt/run
run_vm \
$assets_folder \
$qemu_aarch64_cmd \
-M virt,virtualization=on,secure=on,gic-version=3 \
-M acpi=off -cpu max,x-rme=on,pauth-impdef=on -m 2G \
-nographic \
-bios $assets_folder/out/bin/flash.bin \
-kernel $assets_folder/out/bin/Image \
-drive format=raw,if=none,file=$assets_folder/out-br/images/rootfs.ext4,id=hd0 \
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
-device virtio-net-pci,netdev=net0 -netdev user,id=net0 \
-device virtio-9p-device,fsdev=shr0,mount_tag=shr0 \
-fsdev local,security_model=none,path=$assets_folder,id=shr0 \
-append '"root=/dev/vda console=hvc0 nokaslr"'
