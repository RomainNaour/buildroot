################################################################################
#
# ecrire
#
################################################################################

ECRIRE_VERSION = e89d8b4f13683cda4f952c2296e5d627d70113d2
ECRIRE_SITE = http://git.enlightenment.org/apps/ecrire.git
ECRIRE_SITE_METHOD = git
ECRIRE_LICENSE = GPLv3
ECRIRE_LICENSE_FILES = COPYING

ECRIRE_DEPENDENCIES = efl

$(eval $(cmake-package))
