################################################################################
#
# hurd
#
################################################################################

HURD_VERSION = v0.9.git20200930
HURD_SITE = https://git.savannah.gnu.org/git/hurd/hurd.git
HURD_SITE_METHOD = git
HURD_LICENSE = GPL-3.0
HURD_LICENSE_FILES = COPYING
# Fetched from git
HURD_AUTORECONF = YES
HURD_INSTALL_STAGING = YES

# no libio.h since it was removed from glibc 2.28.
# https://wiki.gentoo.org/wiki/Glibc_2.28_porting_notes/libio_h_removal

HURD_DEPENDENCIES = host-pkgconf bzip2 libdaemon libgcrypt libpciaccess zlib

HURD_CONF_ENV = \
	ac_cv_path_LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config

HURD_CONF_OPTS = --disable-profile --without-parted \
	--prefix=/hurd --exec-prefix=/

HURD_MAKE = $(MAKE1)

$(eval $(autotools-package))
