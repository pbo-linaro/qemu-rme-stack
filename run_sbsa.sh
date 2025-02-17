#!/usr/bin/env bash

set -euo pipefail

source ./common.sh

board=sbsa
out=$(assets_folder $board)

# virtio-9p-device:
# this shares the current directory with the host, providing the files needed
# to run the guest.
# -serial: the following parameters allow to use separate consoles for
# Firmware (port 54320), Secure payload (54321), host (54322) and guest (54323).
run_vm \
$board \
qemu-system-aarch64 \
-M sbsa-ref \
-cpu max,x-rme=on,sme=off,pauth-impdef=on -m 2G \
-nographic \
-drive file=$out/images/SBSA_FLASH0.fd,format=raw,if=pflash \
-drive file=$out/images/SBSA_FLASH1.fd,format=raw,if=pflash \
-drive file=fat:rw:$out/images/disks/virtual,format=raw \
-drive format=raw,if=none,file=$out/out-br/images/rootfs.ext4,id=hd0 \
-device virtio-blk-pci,drive=hd0 \
-nodefaults \
-serial tcp:localhost:54320 \
-serial tcp:localhost:54321 \
-chardev socket,mux=on,id=hvc0,port=54322,host=localhost \
-device virtio-serial-pci \
-device virtconsole,chardev=hvc0 \
-chardev socket,mux=on,id=hvc1,port=54323,host=localhost \
-device virtio-serial-pci \
-device virtconsole,chardev=hvc1 \
-device virtio-net-pci,netdev=net0 -netdev user,id=net0 \
-device virtio-9p-pci,fsdev=shr0,mount_tag=shr0 \
-fsdev local,security_model=none,path=$out,id=shr0
