################################################################################
#
# gnumach
#
################################################################################

GNUMACH_VERSION = a76bc939142f61e615fcc39fc940961e39a26207
GNUMACH_SITE = https://git.savannah.gnu.org/git/hurd/gnumach.git
GNUMACH_SITE_METHOD = git
# Fetched from git
GNUMACH_AUTORECONF = YES
GNUMACH_INSTALL_STAGING = YES

GNUMACH_CONF_OPTS = --enable-device-drivers=qemu

GNUMACH_MAKE = $(MAKE1)

GNUMACH_MAKE_OPTS = ctags all

$(eval $(autotools-package))
