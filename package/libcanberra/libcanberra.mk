################################################################################
#
# libcanberra
#
################################################################################

LIBCANBERRA_VERSION = 0.30
LIBCANBERRA_SOURCE = libcanberra-$(LIBCANBERRA_VERSION).tar.xz
LIBCANBERRA_SITE = http://0pointer.de/lennart/projects/libcanberra/
LIBCANBERRA_LICENSE = LGPL
LIBCANBERRA_LICENSE_FILES = LGPL

LIBCANBERRA_DEPENDENCIES = libvorbis

LIBCANBERRA_INSTALL_STAGING = YES

$(eval $(autotools-package))
