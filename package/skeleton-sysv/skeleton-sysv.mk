################################################################################
#
# skeleton-sysv
#
################################################################################

SKELETON_SYSV_SOURCE =

SKELETON_SYSV_PROVIDES = skeleton

SKELETON_SYSV_DEPENDENCIES = skeleton-common

SKELETON_SYSV_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_SYSV_ADD_SKELETON_DEPENDENCY = NO

SKELETON_SYSV_INSTALL_STAGING = YES

# Provided by the 'skeleton' package:
# - SKELETON_USR_SYMLINKS_OR_DIRS
# - SKELETON_LIB_SYMLINK
# - SKELETON_TARGET_GENERIC_HOSTNAME
# - SKELETON_TARGET_GENERIC_ISSUE
# - SKELETON_TARGET_ROOT_PASSWD
# - SKELETON_TARGET_GENERIC_BIN_SH
# - SKELETON_TARGET_GENERIC_GETTY_PORT
# - SKELETON_TARGET_GENERIC_GETTY_BAUDRATE
# - SKELETON_TARGET_GENERIC_GETTY_TERM
# - SKELETON_TARGET_GENERIC_GETTY_OPTIONS
# - SKELETON_SET_NETWORK_IFUPDOWN_LOOPBACK
# - SKELETON_SET_NETWORK_IFUPDOWN_DHCP

# Even without a configured DHCP interface, we still need the network part
# of the skeleton, because it is used to configure the loopback interface.
define SKELETON_SYSV_INSTALL_TARGET_CMDS
	$(call SKELETON_RSYNC,system/skeleton-sysv,$(TARGET_DIR))
	$(call SKELETON_RSYNC,system/skeleton-net,$(TARGET_DIR))
endef

define SKELETON_SYSV_SET_NETWORK
	mkdir -p $(TARGET_DIR)/etc/network/
	$(SKELETON_SET_NETWORK_IFUPDOWN_LOOPBACK)
	$(SKELETON_SET_NETWORK_IFUPDOWN_DHCP)
endef
SKELETON_SYSV_TARGET_FINALIZE_HOOKS += SKELETON_SYSV_SET_NETWORK

ifeq ($(BR2_TARGET_GENERIC_GETTY),y)
ifeq ($(BR2_INIT_SYSV),y)
# In sysvinit inittab, the "id" must not be longer than 4 bytes, so we
# skip the "tty" part and keep only the remaining.
define SKELETON_SYSV_SET_GETTY
	$(SED) '/# GENERIC_SERIAL$$/s~^.*#~$(shell echo $(SKELETON_TARGET_GENERIC_GETTY_PORT) | tail -c+4)::respawn:/sbin/getty -L $(SKELETON_TARGET_GENERIC_GETTY_OPTIONS) $(SKELETON_TARGET_GENERIC_GETTY_PORT) $(SKELETON_TARGET_GENERIC_GETTY_BAUDRATE) $(SKELETON_TARGET_GENERIC_GETTY_TERM) #~' \
		$(TARGET_DIR)/etc/inittab
endef
else ifeq ($(BR2_INIT_BUSYBOX),y)
# Add getty to busybox inittab
define SKELETON_SYSV_SET_GETTY
	$(SED) '/# GENERIC_SERIAL$$/s~^.*#~$(SKELETON_TARGET_GENERIC_GETTY_PORT)::respawn:/sbin/getty -L $(SKELETON_TARGET_GENERIC_GETTY_OPTIONS) $(SKELETON_TARGET_GENERIC_GETTY_PORT) $(SKELETON_TARGET_GENERIC_GETTY_BAUDRATE) $(SKELETON_TARGET_GENERIC_GETTY_TERM) #~' \
		$(TARGET_DIR)/etc/inittab
endef
endif
SKELETON_SYSV_TARGET_FINALIZE_HOOKS += SKELETON_SYSV_SET_GETTY
endif

ifeq ($(BR2_INIT_BUSYBOX)$(BR2_INIT_SYSV),y)
ifeq ($(BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW),y)
# Find commented line, if any, and remove leading '#'s
define SKELETON_SYSV_REMOUNT_RW
	$(SED) '/^#.*-o remount,rw \/$$/s~^#\+~~' $(TARGET_DIR)/etc/inittab
endef
else
# Find uncommented line, if any, and add a leading '#'
define SKELETON_SYSV_REMOUNT_RW
	$(SED) '/^[^#].*-o remount,rw \/$$/s~^~#~' $(TARGET_DIR)/etc/inittab
endef
endif
SKELETON_SYSV_TARGET_FINALIZE_HOOKS += SKELETON_SYSV_REMOUNT_RW
endif # BR2_INIT_BUSYBOX || BR2_INIT_SYSV

$(eval $(generic-package))
