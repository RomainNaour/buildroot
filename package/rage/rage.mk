################################################################################
#
# rage
#
################################################################################

RAGE_VERSION = 0.1.4
RAGE_SOURCE = rage-$(RAGE_VERSION).tar.xz
RAGE_SITE = https://download.enlightenment.org/rel/apps/rage/
RAGE_LICENSE = BSD
RAGE_LICENSE_FILES = COPYING

RAGE_DEPENDENCIES = efl

RAGE_CONF_OPTS += --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc

$(eval $(autotools-package))
