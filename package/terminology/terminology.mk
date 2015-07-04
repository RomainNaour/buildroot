################################################################################
#
# terminology
#
################################################################################

TERMINOLOGY_VERSION = 0.8.0
TERMINOLOGY_SOURCE = terminology-$(TERMINOLOGY_VERSION).tar.xz
TERMINOLOGY_SITE = https://download.enlightenment.org/rel/apps/terminology/
TERMINOLOGY_LICENSE = BSD
TERMINOLOGY_LICENSE_FILES = COPYING

TERMINOLOGY_DEPENDENCIES = efl libelementary

TERMINOLOGY_CONF_OPTS += --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc

$(eval $(autotools-package))
