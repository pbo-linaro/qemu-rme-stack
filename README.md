QEMU RME Stack
===============

Build RME Stack using a container.
Full instructions are [here](https://linaro.atlassian.net/wiki/spaces/QEMU/pages/29051027459/Building+an+RME+stack+for+QEMU#With-the-OP-TEE-build-environment).

You need podman installed to build and debug machines.
You need tmux installed to run and debug machines.

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

# to debug running kernel, and trusted firmwares (TF-A, TF-RMM), you can build
# and debug a machine with:
./container.sh ./build_virt_debug.sh
./debug_virt.sh /path/to/qemu-system-aarch64
./container.sh ./build_virt_debug.sh
./debug_sbsa.sh /path/to/qemu-system-aarch64
```
