#!/usr/bin/env bash

set -euo pipefail

source ./common.sh

build_for_board \
    sbsa \
    out/bin/Image \
    out-br/images/rootfs.cpio \
    out-br/images/rootfs.ext4 \
    images/disks/virtual \
    images/SBSA_FLASH0.fd \
    images/SBSA_FLASH1.fd \
    trusted-firmware-a/build/qemu_sbsa/debug/bl1/bl1.elf \
    trusted-firmware-a/build/qemu_sbsa/debug/bl2/bl2.elf \
    trusted-firmware-a/build/qemu_sbsa/debug/bl31/bl31.elf \
    rmm/build/Debug/rmm.elf \
    linux/vmlinux
