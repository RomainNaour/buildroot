################################################################################
#
# libetrophy
#
################################################################################

LIBETROPHY_VERSION = 0.5.1
LIBETROPHY_SOURCE = etrophy-$(LIBETROPHY_VERSION).tar.bz2
LIBETROPHY_SITE = https://download.enlightenment.org/releases/
LIBETROPHY_LICENSE = BSD
LIBETROPHY_LICENSE_FILES = COPYING

LIBETROPHY_DEPENDENCIES = efl libelementary

LIBETROPHY_INSTALL_STAGING = YES

LIBETROPHY_CONF_OPTS += --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc

$(eval $(autotools-package))
