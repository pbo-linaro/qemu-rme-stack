#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "usage: qemu_aarch64_cmd"
    exit 1
fi

source ./common.sh

assets=virt/run
cat > $assets/gdb << EOF
# If you want to debug edk2, stack must be built with EDK2_BUILD=DEBUG.
# For edk2, we need to find where each file is loaded.
# Check QEMU output for 'Loading DxeCore at 0x00BF265000 EntryPoint=0x00BF26E8F4'
# add-symbol-file $assets/edk2/Build/ArmVirtQemuKernel-AARCH64/DEBUG_GCC5/AARCH64/DxeCore.debug 0x00BF265000
# b DxeMain

set pagination off
source gdb_next.py

add-symbol-file $assets/trusted-firmware-a/build/qemu/debug/bl1/bl1.elf
b bl1_main
add-symbol-file $assets/trusted-firmware-a/build/qemu/debug/bl2/bl2.elf
b bl2_main
add-symbol-file $assets/trusted-firmware-a/build/qemu/debug/bl31/bl31.elf
b bl31_main

# TF-A reports where it loads the RMM.
# Reserved RMM memory [0x40100000, 0x428fffff] in Device tree
add-symbol-file $assets/rmm/build/Debug/rmm.elf 0x40100000
b rmm_main

add-symbol-file $assets/linux/vmlinux
b start_kernel

target remote :1234
# reach bl1_main
c
EOF

export RUN_VM_TMUX_EXTRA_COMMANDS="new-window ./container.sh cgdb -d gdb-multiarch -x $assets/gdb"
./run_virt.sh "$@" -S -s
