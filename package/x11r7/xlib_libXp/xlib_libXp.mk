################################################################################
#
# xlib_libXp -- X.Org Xp library
#
################################################################################

XLIB_LIBXP_VERSION = 1.0.3
XLIB_LIBXP_SOURCE = libXp-$(XLIB_LIBXP_VERSION).tar.bz2
XLIB_LIBXP_SITE = http://xorg.freedesktop.org/releases/individual/lib/
XLIB_LIBXP_LICENSE = MIT
XLIB_LIBXP_LICENSE_FILES = COPYING
XLIB_LIBXP_INSTALL_STAGING = YES
XLIB_LIBXP_DEPENDENCIES = host-pkgconf \
	xlib_libX11 \
	xlib_libXau \
	xlib_libXext \
	xproto_printproto

$(eval $(autotools-package))
