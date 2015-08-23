################################################################################
#
# espionage
#
################################################################################

ESPIONAGE_VERSION = c7fa0fba78de984ccd02611e1c761cacb6e21570
ESPIONAGE_SITE = http://git.enlightenment.org/apps/espionage.git
ESPIONAGE_SITE_METHOD = git
ESPIONAGE_LICENSE = GPLv3
ESPIONAGE_LICENSE_FILES = COPYING
ESPIONAGE_SETUP_TYPE = distutils

ESPIONAGE_DEPENDENCIES = host-efl efl python-efl

$(eval $(python-package))
