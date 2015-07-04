################################################################################
#
# econnman
#
################################################################################

ECONNMAN_VERSION = 1.1
ECONNMAN_SITE = https://download.enlightenment.org/rel/apps/econnman/
ECONNMAN_LICENSE = GPLv3
ECONNMAN_LICENSE_FILES = COPYING

ECONNMAN_DEPENDENCIES = dbus-python efl libelementary

ifeq ($(BR2_PACKAGE_PYTHON),y)
ECONNMAN_DEPENDENCIES += python host-python
else
ECONNMAN_DEPENDENCIES += python3 host-python3
endif

ECONNMAN_CONF_OPTS += --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc

$(eval $(autotools-package))
