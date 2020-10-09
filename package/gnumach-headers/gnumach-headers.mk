################################################################################
#
# gnumach-headers
#
################################################################################

GNUMACH_HEADERS_VERSION = a76bc939142f61e615fcc39fc940961e39a26207
GNUMACH_HEADERS_SITE = https://git.savannah.gnu.org/git/hurd/gnumach.git
GNUMACH_HEADERS_SITE_METHOD = git
GNUMACH_HEADERS_AUTORECONF = YES
GNUMACH_HEADERS_ADD_TOOLCHAIN_DEPENDENCY = NO
GNUMACH_HEADERS_INSTALL_STAGING = YES
GNUMACH_HEADERS_INSTALL_TARGET = NO

# Fetched from git, we just need to regenerate Makefile.
GNUMACH_HEADERS_AUTORECONF = YES

# `$TARGET-gcc' doesn't work yet (to satisfy the Autoconf checks), but isn't
# needed either.
GNUMACH_HEADERS_CONF_ENV = CC="$(HOSTCC)"

GNUMACH_HEADERS_DEPENDENCIES = host-gcc-initial

define GNUMACH_HEADERS_BUILD_CMDS
	echo "build"
endef

define GNUMACH_HEADERS_INSTALL_STAGING_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
			INSTALL_DATA="$(INSTALL) -m 644" \
			includedir="/include/" \
			$(MAKE) \
			DESTDIR="$(STAGING_DIR)" \
			PREFIX="/usr" \
			install-data)
endef

$(eval $(autotools-package))
