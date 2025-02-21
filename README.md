QEMU RME Stack
===============

Build RME Stack using a container.
Full instructions are [here](https://linaro.atlassian.net/wiki/spaces/QEMU/pages/29051027459/Building+an+RME+stack+for+QEMU#With-the-OP-TEE-build-environment).

You need podman installed to build and debug machines.
You need tmux installed to run and debug machines.

To build machines:
```
./container.sh ./build_virt.sh
./container.sh ./build_sbsa.sh
```

To run machines in a tmux session with qemu:
```
./run_virt.sh /path/to/qemu-system-aarch64
./run_sbsa.sh /path/to/qemu-system-aarch64

# login in Host using 'root' user (no password)
# run guest using
/mnt/realm_vm.sh
```

To debug the kernel and trusted firmwares (TF-A, TF-RMM), you can build
and debug a machine with:
```
./container.sh ./build_virt_debug.sh
./debug_virt.sh /path/to/qemu-system-aarch64
./container.sh ./build_virt_debug.sh
./debug_sbsa.sh /path/to/qemu-system-aarch64

Two new commands are available in gdb: next-binary, next-source.
They allow to continue execution until source file change, or current binary
change. It can be used to track exception level changes or interrupts.
```
