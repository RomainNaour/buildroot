################################################################################
#
# libelementary
#
################################################################################

LIBELEMENTARY_VERSION = $(EFL_VERSION)
LIBELEMENTARY_SOURCE = elementary-$(LIBELEMENTARY_VERSION).tar.xz
LIBELEMENTARY_SITE = http://download.enlightenment.org/rel/libs/elementary/
LIBELEMENTARY_LICENSE = LGPLv2.1
LIBELEMENTARY_LICENSE_FILES = COPYING

LIBELEMENTARY_INSTALL_STAGING = YES

LIBELEMENTARY_DEPENDENCIES = efl-core

LIBELEMENTARY_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eet-eet=$(HOST_DIR)/usr/bin/eet

$(eval $(autotools-package))
