#!/usr/bin/env bash

set -euo pipefail

source ./common.sh

build_folder=sbsa/build
assets_folder=sbsa/run

build_board \
    $build_folder \
    sbsa_cca.xml \
    $CCA_VERSION

copy_assets \
    $build_folder \
    $assets_folder \
    out/bin/Image \
    out-br/images/rootfs.cpio \
    out-br/images/rootfs.ext4 \
    images/disks/virtual \
    images/SBSA_FLASH0.fd \
    images/SBSA_FLASH1.fd
