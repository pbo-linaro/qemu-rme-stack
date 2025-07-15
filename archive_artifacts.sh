#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: board out_tar_xz"
    echo "board: virt | sbsa"
    exit 1
fi

board=$1; shift
out=$1; shift

if ! [[ "$out" =~ .*.tar.xz ]]; then
    echo "$out should be a .tar.xz archive"
    exit 1
fi

case $board in
    virt) ;;
    sbsa) ;;
    *) echo "board should be virt or sbsa"; exit 1;;
esac

du -hc $board/run/
# create a sparse archive with:
# - kernel
# - guest rootfs
# - host rootfs
pushd $board/run/
tar cJvfS $out ./
du -h $out
popd
