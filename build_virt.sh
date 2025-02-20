#!/usr/bin/env bash

set -euo pipefail

source ./common.sh

build_folder=virt/build
assets_folder=virt/run

build_board \
    $build_folder \
    qemu_v8_cca.xml \
    cca/v4

copy_assets \
    $build_folder \
    $assets_folder \
    out/bin/Image \
    out-br/images/rootfs.cpio \
    out-br/images/rootfs.ext4 \
    out/bin/flash.bin \
    trusted-firmware-a/build/qemu/debug/bl1/bl1.elf \
    trusted-firmware-a/build/qemu/debug/bl2/bl2.elf \
    trusted-firmware-a/build/qemu/debug/bl31/bl31.elf \
    rmm/build/Debug/rmm.elf \
    linux/vmlinux
