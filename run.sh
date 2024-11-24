#!/usr/bin/env bash

set -euo pipefail

podman build -t build-rme-stack - < ./Dockerfile
podman run -it --rm -v $(pwd):$(pwd) -w $(pwd) --init build-rme-stack "$@"
