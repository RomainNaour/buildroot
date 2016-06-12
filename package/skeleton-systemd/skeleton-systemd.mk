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
ifeq ($(BR2_PACKAGE_SYSTEMD_NETWORKD),)

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

define SKELETON_SYSTEMD_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc
	mkdir -p $(TARGET_DIR)/home
	mkdir -p $(TARGET_DIR)/srv
	mkdir -p $(TARGET_DIR)/var
	echo "/dev/root / auto rw 0 1" >$(TARGET_DIR)/etc/fstab
	ln -sf ../usr/share/zoneinfo/$(SKELETON_SYSTEMD_LOCALTIME) \
		$(TARGET_DIR)/etc/localtime
	$(SKELETON_SYSTEMD_RSYNC_NETWORK)
endef

$(eval $(generic-package))
