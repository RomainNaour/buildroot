################################################################################
#
# libelementary
#
################################################################################

LIBELEMENTARY_VERSION = 1.14.2
LIBELEMENTARY_SOURCE = elementary-$(LIBELEMENTARY_VERSION).tar.xz
LIBELEMENTARY_SITE = http://download.enlightenment.org/rel/libs/elementary/
LIBELEMENTARY_LICENSE = LGPLv2.1
LIBELEMENTARY_LICENSE_FILES = COPYING

LIBELEMENTARY_INSTALL_STAGING = YES

LIBELEMENTARY_DEPENDENCIES = host-pkgconf host-efl efl

LIBELEMENTARY_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eet-eet=$(HOST_DIR)/usr/bin/eet \
	--with-eolian-gen=$(HOST_DIR)/usr/bin/eolian_gen \
	--with-eldbus_codegen=$(HOST_DIR)/usr/bin/eldbus-codegen \
	--with-doxygen=no \
	--disable-elementary-test

$(eval $(autotools-package))
