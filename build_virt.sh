#!/usr/bin/env bash

set -euo pipefail

source ./common.sh

build_for_board \
    qemu_v8 \
    out/bin/Image \
    out-br/images/rootfs.cpio \
    out-br/images/rootfs.ext4 \
    out/bin/flash.bin \
    trusted-firmware-a/build/qemu/debug/bl1/bl1.elf \
    trusted-firmware-a/build/qemu/debug/bl2/bl2.elf \
    trusted-firmware-a/build/qemu/debug/bl31/bl31.elf \
    rmm/build/Debug/rmm.elf \
    linux/vmlinux
