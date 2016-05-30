################################################################################
#
# skeleton-sysv
#
################################################################################

SKELETON_SYSV_SOURCE =

SKELETON_SYSV_PROVIDES = skeleton

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

define SKELETON_SYSV_INSTALL_TARGET_CMDS
	$(call SKELETON_RSYNC,system/skeleton,$(TARGET_DIR))
	$(call SKELETON_USR_SYMLINKS_OR_DIRS,$(TARGET_DIR))
	ln -snf lib $(TARGET_DIR)/$(SKELETON_LIB_SYMLINK)
	ln -snf lib $(TARGET_DIR)/usr/$(SKELETON_LIB_SYMLINK)
	$(INSTALL) -m 0644 support/misc/target-dir-warning.txt \
		$(TARGET_DIR_WARNING_FILE)
endef

# For the staging dir, we don't really care about /bin and /sbin.
# But for consistency with the target dir, and to simplify the code,
# we still handle them for the merged or non-merged /usr cases.
# Since the toolchain is not yet available, the staging is not yet
# populated, so we need to create the directories in /usr
define SKELETON_SYSV_INSTALL_STAGING_CMDS
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/lib
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/bin
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/sbin
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/include
	$(call SKELETON_USR_SYMLINKS_OR_DIRS,$(STAGING_DIR))
	ln -snf lib $(STAGING_DIR)/$(SKELETON_LIB_SYMLINK)
	ln -snf lib $(STAGING_DIR)/usr/$(SKELETON_LIB_SYMLINK)
endef

ifneq ($(SKELETON_TARGET_GENERIC_HOSTNAME),)
define SKELETON_SYSV_SET_HOSTNAME
	mkdir -p $(TARGET_DIR)/etc
	echo "$(SKELETON_TARGET_GENERIC_HOSTNAME)" > $(TARGET_DIR)/etc/hostname
	$(SED) '$$a \127.0.1.1\t$(SKELETON_TARGET_GENERIC_HOSTNAME)' \
		-e '/^127.0.1.1/d' $(TARGET_DIR)/etc/hosts
endef
SKELETON_SYSV_TARGET_FINALIZE_HOOKS += SKELETON_SYSV_SET_HOSTNAME
endif

ifneq ($(SKELETON_TARGET_GENERIC_ISSUE),)
define SKELETON_SYSV_SET_ISSUE
	mkdir -p $(TARGET_DIR)/etc
	echo "$(SKELETON_TARGET_GENERIC_ISSUE)" > $(TARGET_DIR)/etc/issue
endef
SKELETON_SYSV_TARGET_FINALIZE_HOOKS += SKELETON_SYSV_SET_ISSUE
endif

define SKELETON_SYSV_SET_NETWORK
	mkdir -p $(TARGET_DIR)/etc/network/
	$(SKELETON_SET_NETWORK_IFUPDOWN_LOOPBACK)
	$(SKELETON_SET_NETWORK_IFUPDOWN_DHCP)
endef
SKELETON_SYSV_TARGET_FINALIZE_HOOKS += SKELETON_SYSV_SET_NETWORK

define SKELETON_SYSV_SET_ROOT_PASSWD
	$(SED) s,^root:[^:]*:,root:$(SKELETON_SYSV_ROOT_PASSWORD):, $(TARGET_DIR)/etc/shadow
endef
SKELETON_SYSV_TARGET_FINALIZE_HOOKS += SKELETON_SYSV_SET_ROOT_PASSWD

ifeq ($(BR2_SYSTEM_BIN_SH_NONE),y)
define SKELETON_SYSV_BIN_SH
	rm -f $(TARGET_DIR)/bin/sh
endef
else
define SKELETON_SYSV_BIN_SH
	ln -sf $(SKELETON_TARGET_GENERIC_BIN_SH) $(TARGET_DIR)/bin/sh
endef
endif
SKELETON_SYSV_TARGET_FINALIZE_HOOKS += SKELETON_SYSV_BIN_SH

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
