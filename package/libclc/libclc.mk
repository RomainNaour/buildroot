################################################################################
#
# libclc
#
################################################################################

LIBCLC_VERSION = 17648cd846390e294feafef21c32c7106eac1e24
LIBCLC_SITE = http://llvm.org/git/libclc.git
LIBCLC_SITE_METHOD = git

LIBCLC_DEPENDENCIES = host-clang host-llvm

LIBCLC_INSTALL_STAGING = YES

LIBCLC_CONF_OPTS = --with-llvm-config=$(HOST_DIR)/usr/bin/llvm-config \
	--prefix="/usr" \
	--pkgconfigdir="/usr/lib/pkgconfig"

define LIBCLC_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure.py $(LIBCLC_CONF_OPTS))
endef

define LIBCLC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBCLC_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define LIBCLC_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))
