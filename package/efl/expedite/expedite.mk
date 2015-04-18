################################################################################
#
# expedite
#
################################################################################

# efl-1.14 branch
EXPEDITE_VERSION = 9b7d97d5034de22cf8090f5f598eeceab5aa1165
EXPEDITE_SITE = http://git.enlightenment.org/tools/expedite.git
EXPEDITE_SITE_METHOD = git
EXPEDITE_LICENSE = BSD-2c
EXPEDITE_LICENSE_FILES = COPYING

EXPEDITE_DEPENDENCIES = efl-core

# There is no configure script in git tree.
EXPEDITE_AUTORECONF = YES

$(eval $(autotools-package))
