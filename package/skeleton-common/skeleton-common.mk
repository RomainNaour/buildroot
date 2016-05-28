################################################################################
#
# skeleton-common
#
################################################################################

SKELETON_COMMON_SOURCE =

SKELETON_COMMON_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_COMMON_ADD_SKELETON_DEPENDENCY = NO

SKELETON_COMMON_INSTALL_STAGING = YES

SKELETON_COMMON_PATH = system/skeleton

# Provided by the 'skeleton' package:
# - SKELETON_USR_SYMLINKS_OR_DIRS
# - SKELETON_LIB_SYMLINK

SKELETON_COMMON_TARGET_GENERIC_HOSTNAME = $(call qstrip,$(BR2_TARGET_GENERIC_HOSTNAME))
SKELETON_COMMON_TARGET_GENERIC_ISSUE = $(call qstrip,$(BR2_TARGET_GENERIC_ISSUE))
SKELETON_COMMON_TARGET_GENERIC_ROOT_PASSWD = $(call qstrip,$(BR2_TARGET_GENERIC_ROOT_PASSWD))
SKELETON_COMMON_TARGET_GENERIC_PASSWD_METHOD = $(call qstrip,$(BR2_TARGET_GENERIC_PASSWD_METHOD))
SKELETON_COMMON_TARGET_GENERIC_BIN_SH = $(call qstrip,$(BR2_SYSTEM_BIN_SH))

ifeq ($(BR2_TARGET_ENABLE_ROOT_LOGIN),y)
ifeq ($(SKELETON_TARGET_GENERIC_ROOT_PASSWD),)
SKELETON_COMMON_ROOT_PASSWORD =
else ifneq ($(filter $$1$$% $$5$$% $$6$$%,$(SKELETON_TARGET_GENERIC_ROOT_PASSWD)),)
SKELETON_COMMON_ROOT_PASSWORD = '$(SKELETON_TARGET_GENERIC_ROOT_PASSWD)'
else
SKELETON_COMMON_DEPENDENCIES += host-mkpasswd
# This variable will only be evaluated in the finalize stage, so we can
# be sure that host-mkpasswd will have already been built by that time.
SKELETON_COMMON_ROOT_PASSWORD = "`$(MKPASSWD) -m "$(SKELETON_TARGET_GENERIC_PASSWD_METHOD)" "$(SKELETON_TARGET_GENERIC_ROOT_PASSWD)"`"
endif
else # !BR2_TARGET_ENABLE_ROOT_LOGIN
SKELETON_COMMON_ROOT_PASSWORD = "*"
endif

define SKELETON_COMMON_INSTALL_TARGET_CMDS
	$(call SKELETON_RSYNC,$(SKELETON_COMMON_PATH),$(TARGET_DIR))
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
define SKELETON_COMMON_INSTALL_STAGING_CMDS
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/lib
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/bin
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/sbin
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/include
	$(call SKELETON_USR_SYMLINKS_OR_DIRS,$(STAGING_DIR))
	ln -snf lib $(STAGING_DIR)/$(SKELETON_LIB_SYMLINK)
	ln -snf lib $(STAGING_DIR)/usr/$(SKELETON_LIB_SYMLINK)
endef

ifneq ($(SKELETON_COMMON_TARGET_GENERIC_HOSTNAME),)
define SKELETON_COMMON_SET_HOSTNAME
	mkdir -p $(TARGET_DIR)/etc
	echo "$(SKELETON_COMMON_TARGET_GENERIC_HOSTNAME)" > $(TARGET_DIR)/etc/hostname
	$(SED) '$$a \127.0.1.1\t$(SKELETON_COMMON_TARGET_GENERIC_HOSTNAME)' \
		-e '/^127.0.1.1/d' $(TARGET_DIR)/etc/hosts
endef
SKELETON_COMMON_TARGET_FINALIZE_HOOKS += SKELETON_COMMON_SET_HOSTNAME
endif

ifneq ($(SKELETON_COMMON_TARGET_GENERIC_ISSUE),)
define SKELETON_COMMON_SET_ISSUE
	mkdir -p $(TARGET_DIR)/etc
	echo "$(SKELETON_COMMON_TARGET_GENERIC_ISSUE)" > $(TARGET_DIR)/etc/issue
endef
SKELETON_COMMON_TARGET_FINALIZE_HOOKS += SKELETON_COMMON_SET_ISSUE
endif

define SKELETON_COMMON_SET_ROOT_PASSWD
	$(SED) s,^root:[^:]*:,root:$(SKELETON_COMMON_ROOT_PASSWORD):, $(TARGET_DIR)/etc/shadow
endef
SKELETON_COMMON_TARGET_FINALIZE_HOOKS += SKELETON_COMMON_SET_ROOT_PASSWD

ifeq ($(BR2_SYSTEM_BIN_SH_NONE),y)
define SKELETON_COMMON_BIN_SH
	rm -f $(TARGET_DIR)/bin/sh
endef
else
define SKELETON_COMMON_BIN_SH
	ln -sf $(SKELETON_COMMON_TARGET_GENERIC_BIN_SH) $(TARGET_DIR)/bin/sh
endef
endif
SKELETON_COMMON_TARGET_FINALIZE_HOOKS += SKELETON_COMMON_BIN_SH

$(eval $(generic-package))
