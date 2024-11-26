#!/usr/bin/env bash

set -euo pipefail

podman build -t build-rme-stack - < ./Dockerfile
podman run \
    -it --rm -v $(pwd):$(pwd) -w $(pwd) --init \
    -e DISABLE_CONTAINER_CHECK=1 \
    build-rme-stack \
    "$@"
