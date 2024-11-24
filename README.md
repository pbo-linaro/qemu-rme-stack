Build RME Stack
===============

Build RME Stack with OP-TEE using a container.
Full instructions are [here](https://linaro.atlassian.net/wiki/spaces/QEMU/pages/29051027459/Building+an+RME+stack+for+QEMU#With-the-OP-TEE-build-environment).

```
# build image using:
./run.sh ./build.sh
# launch qemu:
PATH=/path/to/qemu:$PATH ./launch_vm.sh
# login in Host using root (no password)
# launch guest using
/mnt/realm_vm.sh
```
