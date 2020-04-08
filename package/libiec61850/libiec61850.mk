################################################################################
#
# libiec61850
#
################################################################################

LIBIEC61850_VERSION = 1.4.2.1
LIBIEC61850_SITE = $(call github,mz-automation,libiec61850,v$(LIBIEC61850_VERSION))
LIBIEC61850_INSTALL_STAGING = YES
LIBIEC61850_LICENSE = GPL-3.0
LIBIEC61850_LICENSE_FILES = COPYING
LIBIEC61850_CONF_OPTS = -DBUILD_PYTHON_BINDINGS=OFF

define LIBIEC61850_COPY_EXAMPLES
	cp -r $(@D)/examples $(TARGET_DIR)/root
endef

ifeq ($(BR2_PACKAGE_LIBIEC61850_BUILD_EXAMPLES),y)
LIBIEC61850_CONF_OPTS += -DBUILD_EXAMPLES=ON
LIBIEC61850_POST_INSTALL_TARGET_HOOKS += LIBIEC61850_COPY_EXAMPLES
else
LIBIEC61850_CONF_OPTS += -DBUILD_EXAMPLES=OFF
endif

$(eval $(cmake-package))
