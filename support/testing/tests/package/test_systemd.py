import os

import infra.basetest

SYSTEMD_TIMEOUT = 1200

# Some unit files used by the systemd testsuite are using some program functionnality
# not implemented by the busybox variant (grep, find).
# The stat command with custom format (-c) and display of filesystem status (-f) used by
# exec-protecthome-tmpfs-vs-protectsystem-strict.service can be provided by busybox or coreutils.
# The ionice command used by exec-ioschedulingclass-none.service is provided by util-linux schedutils.
# libcap tools needed for capsh binary.

# Skipped tests:
# test-barrier: This test requires a baremetal machine, skipping tests.
# test-bus-chat; This test requires an user account.

# TODO: Add BR2_PACKAGE_LIBSECCOMP=y
class TestSystemd(infra.basetest.BRTest):
    br2_external = [infra.filepath("tests/package/br2-external/systemd")]
    config = \
        """
        BR2_x86_core2=y
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TOOLCHAIN_EXTERNAL_CUSTOM=y
        BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD=y
        BR2_TOOLCHAIN_EXTERNAL_URL="http://toolchains.bootlin.com/downloads/releases/toolchains/x86-core2/tarballs/x86-core2--glibc--bleeding-edge-2020.02-2.tar.bz2"
        BR2_TOOLCHAIN_EXTERNAL_GCC_9=y
        BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_19=y
        BR2_TOOLCHAIN_EXTERNAL_CXX=y
        BR2_TOOLCHAIN_EXTERNAL_HAS_SSP=y
        BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC=y
        BR2_LINUX_KERNEL=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION=y
        BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE="5.4.32"
        BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG=y
        BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE="{}"
        BR2_ENABLE_LOCALE_WHITELIST="C en_US C_UTF8 fr_FR"
        BR2_INIT_SYSTEMD=y
        BR2_PACKAGE_ACL=y
        BR2_PACKAGE_BASH_COMPLETION=y
        BR2_PACKAGE_BUSYBOX_CONFIG_FRAGMENT_FILES="{}"
        BR2_PACKAGE_CRYPTSETUP=y
        BR2_PACKAGE_E2FSPROGS=y
        BR2_PACKAGE_ELFUTILS=y
        BR2_PACKAGE_ELFUTILS_PROGS=y
        BR2_PACKAGE_GREP=y
        BR2_PACKAGE_FINDUTILS=y
        BR2_PACKAGE_KBD=y
        BR2_PACKAGE_LESS=y
        BR2_PACKAGE_LIBCAP_TOOLS=y
        BR2_PACKAGE_LIBCGROUP=y
        BR2_PACKAGE_LIBCGROUP_TOOLS=y
        BR2_PACKAGE_LIBIDN2=y
        BR2_PACKAGE_LINUX_PAM=y
        BR2_PACKAGE_PCRE2=y
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_RNG_TOOLS=y
        BR2_PACKAGE_SYSTEMD_JOURNAL_GATEWAY=y
        BR2_PACKAGE_SYSTEMD_JOURNAL_REMOTE=y
        BR2_PACKAGE_SYSTEMD_BACKLIGHT=y
        BR2_PACKAGE_SYSTEMD_BINFMT=y
        BR2_PACKAGE_SYSTEMD_COREDUMP=y
        BR2_PACKAGE_SYSTEMD_FIRSTBOOT=y
        BR2_PACKAGE_SYSTEMD_HIBERNATE=y
        BR2_PACKAGE_SYSTEMD_IMPORTD=y
        BR2_PACKAGE_SYSTEMD_LOCALED=y
        BR2_PACKAGE_SYSTEMD_LOGIND=y
        BR2_PACKAGE_SYSTEMD_MACHINED=y
        BR2_PACKAGE_SYSTEMD_POLKIT=y
        BR2_PACKAGE_SYSTEMD_QUOTACHECK=y
        BR2_PACKAGE_SYSTEMD_RANDOMSEED=y
        BR2_PACKAGE_SYSTEMD_RFKILL=y
        BR2_PACKAGE_SYSTEMD_SMACK_SUPPORT=y
        BR2_PACKAGE_SYSTEMD_SYSUSERS=y
        BR2_PACKAGE_UTIL_LINUX_MINIX=y
        BR2_PACKAGE_UTIL_LINUX_UNSHARE=y
        BR2_PACKAGE_UTIL_LINUX_MOUNTPOINT=y
        BR2_PACKAGE_UTIL_LINUX_SCHEDUTILS=y
        BR2_PACKAGE_VIM=y
        BR2_ROOTFS_OVERLAY="{}"
        BR2_SYSTEM_BIN_SH_BASH=y
        BR2_SYSTEM_DHCP="eth0"
        BR2_SYSTEM_ENABLE_NLS=y
        BR2_TARGET_GENERIC_GETTY_PORT="ttyS0"
        BR2_TARGET_ROOTFS_EXT2=y
        BR2_TARGET_ROOTFS_EXT2_4=y
        BR2_TARGET_ROOTFS_EXT2_SIZE="1G"
        # BR2_TARGET_ROOTFS_TAR is not set
        """.format(
              infra.filepath("tests/package/test_systemd/systemd-kernel.config"),
              infra.filepath("tests/package/test_systemd/busybox.fragment"),
              infra.filepath("tests/package/test_systemd/rootfs-overlay"))

    def login(self):
        img = os.path.join(self.builddir, "images", "rootfs.ext2")
        kern = os.path.join(self.builddir, "images", "bzImage")

        # the complete boot with systemd takes more time than what the default multipler permits
        self.emulator.timeout_multiplier *= 10

        # systemd testsuite overallocate memory and the minimum that seemed to work was 1G
        # systemd.unified_cgroup_hierarchy=1 for cgroup v2 and test-execute
        # https://www.freedesktop.org/wiki/Software/systemd/VirtualizedTesting/
        self.emulator.boot(arch="i386",
                           kernel=kern,
                           kernel_cmdline=["root=/dev/vda", "ro", "console=ttyS0",
                                           "systemd.unified_cgroup_hierarchy=1",
                                           "audit=0 cgroup_no_v1=\"all\""],
                           options=["-M", "pc", "-m", "1G", "-device",
                                    "virtio-rng-pci", "-drive",
                                    "file={},if=virtio,format=raw".format(img)])
        self.emulator.login()

    def test_run(self):
        self.login()

        cmd = "/usr/lib/systemd/tests/run-unit-tests.py"
        _, exit_code = self.emulator.run(cmd, SYSTEMD_TIMEOUT)
        self.assertEqual(exit_code, 0)
