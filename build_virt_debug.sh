#!/usr/bin/env bash

set -euo pipefail

source ./common.sh

build=virt/build_debug
assets=virt/run_debug

build_board \
    $build \
    qemu_v8_cca.xml \
    $CCA_VERSION \
    $BUILD_DEBUG_ARGS

copy_assets \
    $build \
    $assets \
    out/bin/Image \
    out-br/images/rootfs.cpio \
    out-br/images/rootfs.ext4 \
    out/bin/flash.bin \
    trusted-firmware-a/build/qemu/debug/bl1/bl1.elf \
    trusted-firmware-a/build/qemu/debug/bl2/bl2.elf \
    trusted-firmware-a/build/qemu/debug/bl31/bl31.elf \
    rmm/build/Debug/rmm.elf \
    edk2/Build/ArmVirtQemuKernel-AARCH64/DEBUG_GCC5/AARCH64/DxeCore.debug \
    linux/vmlinux

gdb_debug_script $assets qemu edk2/Build/ArmVirtQemuKernel-AARCH64 0x40100000 > $assets/gdb
