QEMU RME Stack
===============

Build RME Stack with OP-TEE using a container.
Full instructions are [here](https://linaro.atlassian.net/wiki/spaces/QEMU/pages/29051027459/Building+an+RME+stack+for+QEMU#With-the-OP-TEE-build-environment).

```
# build image using:
./container.sh ./build_virt.sh # for virt platform
./container.sh ./build_sbsa.sh # for sbsa platform

# launch a tmux session with qemu and various output
PATH=/path/to/qemu:$PATH ./launch_vm_virt.sh # for virt platform
PATH=/path/to/qemu:$PATH ./launch_vm_sbsa.sh # for sbsa platform

# login in Host using root (no password)
# launch guest using
/mnt/realm_vm.sh
```
