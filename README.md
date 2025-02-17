QEMU RME Stack
===============

Build RME Stack using a container.
Full instructions are [here](https://linaro.atlassian.net/wiki/spaces/QEMU/pages/29051027459/Building+an+RME+stack+for+QEMU#With-the-OP-TEE-build-environment).

```
# build image using:
./container.sh ./build_virt.sh # for virt platform
./container.sh ./build_sbsa.sh # for sbsa platform

# run a tmux session with qemu and various output
./run_virt.sh /path/to/qemu-system-aarch64 # for virt platform
./run_sbsa.sh /path/to/qemu-system-aarch64 # for sbsa platform

# login in Host using root (no password)
# run guest using
/mnt/realm_vm.sh
```
