################################################################################
#
# python-elf
#
################################################################################

PYTHON_EFL_VERSION = 1.14.0
PYTHON_EFL_SOURCE = python-efl-$(PYTHON_EFL_VERSION).tar.xz
PYTHON_EFL_SITE = https://download.enlightenment.org/rel/bindings/python/
PYTHON_EFL_LICENSE = GPLv3
PYTHON_EFL_LICENSE_FILES = COPYING COPYING.LESSER
PYTHON_EFL_SETUP_TYPE = distutils
PYTHON_EFL_DEPENDENCIES = dbus-python libelementary efl

ifeq ($(BR2_PACKAGE_PYTHON),y)
PYTHON_EFL_DEPENDENCIES += python host-python
else
PYTHON_EFL_DEPENDENCIES += python3 host-python3
endif

$(eval $(python-package))
