#!/usr/bin/env bash

set -euo pipefail

source ./common.sh

build=sbsa/build_debug
assets=sbsa/run_debug

build_board \
    $build \
    sbsa_cca.xml \
    $CCA_VERSION \
    $BUILD_DEBUG_ARGS

copy_assets \
    $build \
    $assets \
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

gdb_debug_script $assets qemu_sbsa 0x10000000000 > $assets/gdb
