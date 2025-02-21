#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "usage: qemu_aarch64_cmd"
    exit 1
fi

assets=sbsa/run_debug
export RUN=$assets
export RUN_VM_TMUX_EXTRA_COMMANDS="new-window ./container.sh cgdb -d gdb-multiarch -x $assets/gdb"
./run_sbsa.sh "$@" -S -s -smp 1
