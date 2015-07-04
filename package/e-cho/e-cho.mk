################################################################################
#
# e-cho
#
################################################################################

E_CHO_VERSION = 417da4899ead718fcb414530f31c292922e55c19
E_CHO_SITE = http://git.enlightenment.org/games/e_cho.git
E_CHO_SITE_METHOD = git
E_CHO_LICENSE = GPLv3
E_CHO_LICENSE_FILES = COPYING

E_CHO_DEPENDENCIES = efl libcanberra libetrophy

# configure is missing but e-cho seems not compatible with our autoreconf
# mechanism so we have to do it manually instead of using E_CHO_AUTORECONF = YES
define E_CHO_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
E_CHO_PRE_CONFIGURE_HOOKS += E_CHO_RUN_AUTOGEN

E_CHO_CONF_OPTS += --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc

$(eval $(autotools-package))
