# Append SYSTEMD_CONF_OPTS from this BR2_EXTERNAL due to include order in the Buildroot main Makefile:
# -include $(PACKAGE_OVERRIDE_FILE)
# -include $(sort $(wildcard package/*/*.mk))
# include $(BR2_EXTERNAL_FILE)
SYSTEMD_CONF_OPTS += -Dslow-tests=true -Dinstall-tests=true -Dtests=true
