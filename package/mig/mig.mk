################################################################################
#
# mig
#
################################################################################

MIG_VERSION = 88b859c0d1a377d584bda4fb74846ec19a7b958f
MIG_SITE = https://git.savannah.gnu.org/git/hurd/mig.git
MIG_SITE_METHOD = git
# Fetched from git
MIG_AUTORECONF = YES
HOST_MIG_DEPENDENCIES = host-flex gnumach-headers

HOST_MIG_CONF_OPTS = --target=$(GNU_TARGET_NAME) \
	--host=$(GNU_HOST_NAME)

HOST_MIG_CONF_ENV = TARGET_CPPFLAGS="-I$(STAGING_DIR)/usr/include"

$(eval $(host-autotools-package))
