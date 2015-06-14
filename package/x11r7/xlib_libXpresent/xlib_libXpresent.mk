################################################################################
#
# xlib_libXpresent
#
################################################################################

XLIB_LIBXPRESENT_VERSION = 1.0.0
XLIB_LIBXPRESENT_SOURCE = libXpresent-$(XLIB_LIBXPRESENT_VERSION).tar.bz2
XLIB_LIBXPRESENT_SITE = http://xorg.freedesktop.org/archive/individual/lib
XLIB_LIBXPRESENT_LICENSE = MIT
XLIB_LIBXPRESENT_LICENSE_FILES = COPYING
XLIB_LIBXPRESENT_INSTALL_STAGING = YES
XLIB_LIBXPRESENT_DEPENDENCIES = \
	host-pkgconf \
	xlib_libX11 \
	xlib_libXext \
	xlib_libXfixes \
	xlib_libXrandr \
	xproto_presentproto \
	xproto_xproto

$(eval $(autotools-package))
