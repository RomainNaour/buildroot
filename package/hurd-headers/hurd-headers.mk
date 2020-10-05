################################################################################
#
# hurd-headers
#
################################################################################

HURD_HEADERS_VERSION = v0.9.git20200930
HURD_HEADERS_SITE = https://git.savannah.gnu.org/git/hurd/hurd.git
HURD_HEADERS_SITE_METHOD = git
HURD_HEADERS_LICENSE = GPL-3.0
HURD_HEADERS_LICENSE_FILES = COPYING
HURD_HEADERS_INSTALL_STAGING = YES
HURD_HEADERS_INSTALL_TARGET = NO
# hurd-headers is part of the toolchain so disable the toolchain dependency
HURD_HEADERS_ADD_TOOLCHAIN_DEPENDENCY = NO

define HURD_HEADERS_INSTALL_STAGING_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
			INSTALL_DATA="$(INSTALL) -m 644" \
			includedir="/include/" \
			$(MAKE) \
			DESTDIR="$(STAGING_DIR)/usr" \
			PREFIX="/usr" \
			install-headers no_deps=t)
endef

$(eval $(generic-package))
