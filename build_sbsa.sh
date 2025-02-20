#!/usr/bin/env bash

set -euo pipefail

source ./common.sh

build_folder=sbsa/build
assets_folder=sbsa/run

build_board \
    $build_folder \
    sbsa_cca.xml \
    cca/v4

copy_assets \
    $build_folder \
    $assets_folder \
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
