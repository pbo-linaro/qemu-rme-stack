#!/bin/sh

USE_VIRTCONSOLE=true
USE_EDK2=false
USE_INITRD=true
DIRECT_KERNEL_BOOT=true
USE_OPTEE_BUILD=true
VM_MEMORY=512M

if $USE_OPTEE_BUILD; then
    KERNEL=/mnt/out/bin/Image
    INITRD=/mnt/out-br/images/rootfs.cpio
    EDK2=TODO
    DISK=TODO
else
    # Manual method:
    KERNEL=/mnt/linux-cca/arch/arm64/boot/Image
    INITRD=/mnt/buildroot/output/images/rootfs.cpio
    EDK2=/mnt/edk2/Build/ArmVirtQemu-AARCH64/DEBUG_GCC5/FV/QEMU_EFI.fd
    DISK=/mnt/buildroot/output/images/disk.img
fi

add_qemu_arg () {
    QEMU_ARGS="$QEMU_ARGS $@"
}
add_kernel_arg () {
    KERNEL_ARGS="$KERNEL_ARGS $@"
}

add_qemu_arg -M virt,gic-version=3 -cpu host -enable-kvm
add_qemu_arg -smp 2 -m $VM_MEMORY
add_qemu_arg -M confidential-guest-support=rme0
add_qemu_arg -object rme-guest,id=rme0,measurement-algo=sha512
add_qemu_arg -device virtio-net-pci,netdev=net0,romfile=""
add_qemu_arg -netdev user,id=net0

if $USE_VIRTCONSOLE; then
    add_kernel_arg console=hvc0
    add_qemu_arg -nodefaults
    add_qemu_arg -chardev stdio,mux=on,id=hvc0,signal=off
    add_qemu_arg -device virtio-serial-pci -device virtconsole,chardev=hvc0
else
    add_kernel_arg console=ttyAMA0 earlycon
    add_qemu_arg -nographic
fi

if $USE_EDK2; then
    add_qemu_arg -bios $EDK2
fi

if $DIRECT_KERNEL_BOOT; then
    add_qemu_arg -kernel $KERNEL
else
    $USE_INITRD && echo "Initrd requires direct kernel boot" && exit 1
fi

if $USE_INITRD; then
    add_qemu_arg -initrd $INITRD
else
    add_qemu_arg -device virtio-blk-pci,drive=rootfs0
    add_qemu_arg -drive format=raw,if=none,file="$DISK",id=rootfs0
    add_kernel_arg root=/dev/vda2
fi

$USE_EDK2 && $USE_VIRTCONSOLE && ! $USE_INITRD && \
    echo "Don't forget to add console=hvc0 to grub.cfg"

if $DIRECT_KERNEL_BOOT; then
    set -x
    qemu-system-aarch64 $QEMU_ARGS  \
        -append "$KERNEL_ARGS"      \
            </dev/hvc1 >/dev/hvc1
else
    set -x
    qemu-system-aarch64 $QEMU_ARGS  \
            </dev/hvc1 >/dev/hvc1
fi
