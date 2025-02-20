QEMU RME Stack
===============

Build RME Stack using a container.
Full instructions are [here](https://linaro.atlassian.net/wiki/spaces/QEMU/pages/29051027459/Building+an+RME+stack+for+QEMU#With-the-OP-TEE-build-environment).

You need podman installed on your system to build and debug platforms.

```
# build image using:
./container.sh ./build_virt.sh
./container.sh ./build_sbsa.sh

# run a tmux session with qemu and various output
./run_virt.sh /path/to/qemu-system-aarch64
./run_sbsa.sh /path/to/qemu-system-aarch64

# login in Host using root (no password)
# run guest using
/mnt/realm_vm.sh

# to debug running kernel, and trusted firmwares (TF-A, TF-RMM), use:
./debug_virt.sh /path/to/qemu-system-aarch64
./debug_sbsa.sh /path/to/qemu-system-aarch64
```
