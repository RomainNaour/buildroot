################################################################################
#
# skeleton-custom
#
################################################################################

SKELETON_CUSTOM_SOURCE =

SKELETON_CUSTOM_PROVIDES = skeleton

SKELETON_CUSTOM_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_CUSTOM_ADD_SKELETON_DEPENDENCY = NO

SKELETON_CUSTOM_INSTALL_STAGING = YES

SKELETON_CUSTOM_PATH = $(call qstrip,$(BR2_ROOTFS_SKELETON_CUSTOM_PATH))

ifeq ($(BR2_PACKAGE_SKELETON_CUSTOM)$(BR_BUILDING),yy)
ifeq ($(SKELETON_PATH),)
$(error No path specified for the custom skeleton)
endif
endif

# Extract the inode numbers for all of those directories. In case any is
# a symlink, we want to get the inode of the pointed-to directory, so we
# append '/.' to be sure we get the target directory. Since the symlinks
# can be anyway (/bin -> /usr/bin or /usr/bin -> /bin), we do that for
# all of them.
#
SKELETON_CUSTOM_LIB_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/lib/. 2>/dev/null)
SKELETON_CUSTOM_BIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/bin/. 2>/dev/null)
SKELETON_CUSTOM_SBIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/sbin/. 2>/dev/null)
SKELETON_CUSTOM_USR_LIB_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/usr/lib/. 2>/dev/null)
SKELETON_CUSTOM_USR_BIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/usr/bin/. 2>/dev/null)
SKELETON_CUSTOM_USR_SBIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/usr/sbin/. 2>/dev/null)

# Ensure that the custom skeleton has /lib, /bin and /sbin, and their
# /usr counterparts
define SKELETON_CUSTOM_MISSING_DIRS
	if [ -z "$(SKELETON_CUSTOM_LIB_INODE)" ]; then \
		missing+=" /lib"; \
	fi; \
	if [ -z "$(SKELETON_CUSTOM_USR_LIB_INODE)" ]; then \
		missing+=" /usr/lib"; \
	fi; \
	if [ -z "$(SKELETON_CUSTOM_BIN_INODE)" ]; then \
		missing+=" /bin"; \
	fi; \
	if [ -z "$(SKELETON_CUSTOM_USR_BIN_INODE)" ]; then \
		missing+=" /usr/bin"; \
	fi; \
	if [ -z "$(SKELETON_CUSTOM_SBIN_INODE)" ]; then \
		missing+=" /sbin"; \
	fi; \
	if [ -z "$(SKELETON_CUSTOM_USR_SBIN_INODE)" ]; then \
		missing+=" /usr/sbin"; \
	fi; \
	if [ "$${missing" ]; then \
		printf "The custom skeleton in %s is missing\n" "$(SKELETON_CUSTOM_PATH)"; \
		printf "the following directories:\n"; \
		printf "   %s\n" "$${missing}"; \
		exit 1; \
	fi
endef

# For a merged /usr, ensure that /lib, /bin and /sbin and their /usr
# counterparts are appropriately setup symlinks ones to the others.
ifeq ($(BR2_ROOTFS_MERGED_USR),y)

define SKELETON_CUSTOM_MERGED_USR
	if [ $(SKELETON_LIB_INODE) != $(SKELETON_USR_LIB_INODE) ]; then \
		missing+=" /lib"; \
	fi; \
	if [ $(SKELETON_BIN_INODE) != $(SKELETON_USR_BIN_INODE) ]; then \
		missing+=" /bin"; \
	fi; \
	if [ $(SKELETON_SBIN_INODE) != $(SKELETON_USR_SBIN_INODE) ]; then \
		missing+=" /sbin"; \
	fi;
	if [ "$${missing}" ]; then
		printf "The custom skeleton in %s is not\n" "$(SKELETON_CUSTOM_PATH)"; \
		printf "using a merged /usr for the following directories:\n"; \
		printf "   %s\n" "$${missing}"; \
		exit 1; \
	fi
endef

endif # merged /usr

# We used to do the followinf checks in Makefile code, to catch the
# errors as early as possible. But the skeleton is the very first
# package to be installed, so we do the checks in its configure
# commands; they are almost as early as if they were done in Makefile
# code.
define SKELETON_CUSTOM_CONFIGURE_CMDS
	$(SKELETON_CUSTOM_MISSING_DIRS)
	$(SKELETON_CUSTOM_MERGED_USR)
endef

# Provided by the 'skeleton' package:
# - SKELETON_LIB_SYMLINK

define SKELETON_CUSTOM_INSTALL_TARGET_CMDS
	$(call SKELETON_RSYNC,$(SKELETON_CUSTOM_PATH),$(TARGET_DIR))
	ln -snf lib $(TARGET_DIR)/$(SKELETON_LIB_SYMLINK)
	ln -snf lib $(TARGET_DIR)/usr/$(SKELETON_LIB_SYMLINK)
endef

# For the staging dir, we don't really care what we install, but we
# need the /lib and /usr/lib apropriately setup.
# Since we ensure, above, that they are correct in the skeleton, we
# can simply copy it to staging.
define SKELETON_CUSTOM_INSTALL_STAGING_CMDS
	$(call SKELETON_RSYNC,$(SKELETON_CUSTOM_PATH),$(STAGING_DIR))
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/include
	ln -snf lib $(STAGING_DIR)/$(SKELETON_LIB_SYMLINK)
	ln -snf lib $(STAGING_DIR)/usr/$(SKELETON_LIB_SYMLINK)
endef

$(eval $(generic-package))
