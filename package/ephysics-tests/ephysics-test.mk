################################################################################
#
# ephysics-test
#
################################################################################

# version 0.1.0
EPHYSICS_TESTS_VERSION = d797e3c1b99f5538e15b7de987c51d404c4f5908
EPHYSICS_TESTS_SITE = http://git.enlightenment.org/misc/ephysics_tests.git
EPHYSICS_TESTS_SITE_METHOD = git
EPHYSICS_TESTS_LICENSE = BSD
EPHYSICS_TESTS_LICENSE_FILES = COPYING COPYING_ARTS

EPHYSICS_TESTS_DEPENDENCIES = bullet efl

EPHYSICS_TESTS_AUTORECONF = YES

EPHYSICS_TESTS_CONF_OPTS += --with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc

$(eval $(autotools-package))
