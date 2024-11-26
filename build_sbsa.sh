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
    images/SBSA_FLASH1.fd
