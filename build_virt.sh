#!/usr/bin/env bash

set -euo pipefail

source ./common.sh

build_for_board \
    qemu_v8 \
    out/bin/Image \
    out-br/images/rootfs.cpio \
    out-br/images/rootfs.ext4 \
    out/bin/flash.bin
