################################################################################
#
# libemotion-generic-players
#
################################################################################

LIBEMOTION_GENERIC_PLAYERS_VERSION = 1.17.0
LIBEMOTION_GENERIC_PLAYERS_SOURCE = emotion_generic_players-$(LIBEMOTION_GENERIC_PLAYERS_VERSION).tar.xz
LIBEMOTION_GENERIC_PLAYERS_SITE = http://download.enlightenment.org/rel/libs/emotion_generic_players
LIBEMOTION_GENERIC_PLAYERS_LICENSE = BSD-2c
LIBEMOTION_GENERIC_PLAYERS_LICENSE_FILES = COPYING

LIBEMOTION_GENERIC_PLAYERS_INSTALL_STAGING = YES

LIBEMOTION_GENERIC_PLAYERS_DEPENDENCIES = host-pkgconf efl vlc

$(eval $(autotools-package))
