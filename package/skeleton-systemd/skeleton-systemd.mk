################################################################################
#
# skeleton-systemd
#
################################################################################

SKELETON_SYSTEMD_SOURCE =

SKELETON_SYSTEMD_PROVIDES = skeleton

SKELETON_SYSTEMD_DEPENDENCIES = skeleton-common

SKELETON_SYSTEMD_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_SYSTEMD_ADD_SKELETON_DEPENDENCY = NO

# In case we're not using systemd-networkd, use the sysv-like network infra;
# otherwise, the necessary bits are installed by the systemd package.
ifeq ($(BR2_PACKAGE_SYSTEMD_NETWORKD),y)

define SKELETON_SYSTEMD_SET_NETWORK
	mkdir -p $(TARGET_DIR)/etc/systemd/network
	printf '[Match]\nName=%s\n[Network]\nDHCP=yes\n' \
		$(SKELETON_NETWORK_DHCP_IFACE) \
		>$(TARGET_DIR)/etc/systemd/network/$(SKELETON_NETWORK_DHCP_IFACE).network
endef
SKELETON_SYSTEMD_TARGET_FINALIZE_HOOKS += SKELETON_SYSTEMD_SET_NETWORK

else # BR2_PACKAGE_SYSTEMD_NETWORKD is not set

define SKELETON_SYSTEMD_RSYNC_NETWORK
	 $(call SKELETON_RSYNC,system/skeleton-net,$(TARGET_DIR))
endef

define SKELETON_SYSTEMD_SET_NETWORK
	ln -fs ../tmp/resolv.conf $(TARGET_DIR)/etc/resolv.conf
	mkdir -p $(TARGET_DIR)/etc/network/
	$(SKELETON_SET_NETWORK_IFUPDOWN_LOOPBACK)
	$(SKELETON_SET_NETWORK_IFUPDOWN_DHCP)
endef
SKELETON_SYSTEMD_TARGET_FINALIZE_HOOKS += SKELETON_SYSTEMD_SET_NETWORK

endif # BR2_PACKAGE_SYSTEMD_NETWORKD not set

SKELETON_SYSTEMD_LOCALTIME = $(call qstrip,$(BR2_TARGET_LOCALTIME))
ifeq ($(SKELETON_SYSTEMD_LOCALTIME),)
SKELETON_SYSTEMD_LOCALTIME = Etc/UTC
endif

ifeq ($(BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW),y)

define SKELETON_SYSTEMD_ROOT_RW
	echo "/dev/root / auto rw 0 1" >$(TARGET_DIR)/etc/fstab
	mkdir -p $(TARGET_DIR)/var
endef

else

# On a R/O rootfs, /var is a tmpfs filesystem. So, at build time, we
# redirect /var to the "factory settings" location. Just before the
# filesystem gets created, the /var symlink will be replaced with
# a real (but empty) directory, and the "factory files" will be copied
# back there by the tmpfiles.d mechanism.
define SKELETON_SYSTEMD_ROOT_RO
	mkdir -p $(TARGET_DIR)/etc/systemd/tmpfiles.d
	mkdir -p $(TARGET_DIR)/usr/share/factory
	ln -s usr/share/factory $(TARGET_DIR)/var
	echo "/dev/root / auto ro 0 1" >$(TARGET_DIR)/etc/fstab
	echo "tmpfs /var tmpfs mode=1777 0 0" >>$(TARGET_DIR)/etc/fstab
endef

define SKELETON_SYSTEMD_VAR_PRE_FS
	rm -f $(TARGET_DIR)/var
	mkdir $(TARGET_DIR)/var
	for i in $(TARGET_DIR)/usr/share/factory/*; do \
		j="$${i##*/}"; \
		if [ -L "$${i}" ]; then \
			printf "L+! /var/%s - - - - %s\n" \
				"$${j}" "../usr/share/factory/$${j}" \
			|| exit 1; \
		else \
			printf "C! /var/%s - - - -\n" "$${j}" \
			|| exit 1; \
		fi; \
	done >$(TARGET_DIR)/etc/systemd/tmpfiles.d/var-factory.conf
endef
SKELETON_SYSTEMD_FS_PRE_CMD_HOOKS += SKELETON_SYSTEMD_VAR_PRE_FS

define SKELETON_SYSTEMD_VAR_POST_FS
	rm -rf $(TARGET_DIR)/var
	ln -s usr/share/factory $(TARGET_DIR)/var
endef
SKELETON_SYSTEMD_FS_POST_CMD_HOOKS += SKELETON_SYSTEMD_VAR_POST_FS

endif

define SKELETON_SYSTEMD_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc
	mkdir -p $(TARGET_DIR)/home
	mkdir -p $(TARGET_DIR)/srv
	$(SKELETON_SYSTEMD_ROOT_RO)
	$(SKELETON_SYSTEMD_ROOT_RW)
	ln -sf ../usr/share/zoneinfo/$(SKELETON_SYSTEMD_LOCALTIME) \
		$(TARGET_DIR)/etc/localtime
	$(SKELETON_SYSTEMD_RSYNC_NETWORK)
endef

$(eval $(generic-package))
