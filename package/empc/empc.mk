################################################################################
#
# empc
#
################################################################################

EMPC_VERSION = 0.99.0.639
EMPC_SOURCE = empc-$(EMPC_VERSION).tar.xz
EMPC_SITE = https://download.enlightenment.org/rel/apps/empc/
EMPC_LICENSE = GPLv3
EMPC_LICENSE_FILES = COPYING

EMPC_DEPENDENCIES = efl libmpdclient

EMPC_CONF_OPTS += --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eldbus_codegen=$(HOST_DIR)/usr/bin/eldbus-codegen

$(eval $(autotools-package))
