################################################################################
#
# elemines
#
################################################################################

ELEMINES_VERSION = 0.2.3
ELEMINES_SOURCE = elemines-$(ELEMINES_VERSION).tar.bz2
ELEMINES_SITE = https://download.enlightenment.org/releases/
ELEMINES_LICENSE = BSD GPLv2 OFL
ELEMINES_LICENSE_FILES = COPYING GPLv2.txt OFL.txt

ELEMINES_DEPENDENCIES = efl libetrophy

ELEMINES_CONF_OPTS += --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc

$(eval $(autotools-package))
