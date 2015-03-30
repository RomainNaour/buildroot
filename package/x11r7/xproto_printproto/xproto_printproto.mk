################################################################################
#
# xproto_printproto
#
################################################################################

XPROTO_PRINTPROTO_VERSION = 1.0.5
XPROTO_PRINTPROTO_SOURCE = printproto-$(XPROTO_PRINTPROTO_VERSION).tar.bz2
XPROTO_PRINTPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_PRINTPROTO_LICENSE = MIT
XPROTO_PRINTPROTO_LICENSE_FILES = COPYING
XPROTO_PRINTPROTO_INSTALL_STAGING = YES
XPROTO_PRINTPROTO_INSTALL_TARGET = NO
XPROTO_PRINTPROTO_DEPENDENCIES = xutil_util-macros

$(eval $(autotools-package))
