Run with qemu:

For ck860 smp:
qemu_csky860_virt_defconfig: qemu-system-cskyv2 -M virt -cpu ck860 -smp 2 -nographic -kernel vmlinux

For ck807:
qemu_csky807_virt_defconfig: qemu-system-cskyv2 -M virt -nographic -kernel vmlinux

For ck810:
qemu_csky810_virt_defconfig: qemu-system-cskyv2 -M virt -nographic -kernel vmlinux

For ck610:
qemu_csky610_virt_defconfig: qemu-system-cskyv1 -M virt -nographic -kernel vmlinux

The login prompt will appear in the terminal that started Qemu. Username is root and no password.
