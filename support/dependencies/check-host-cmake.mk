BR2_CMAKE ?= cmake

ifneq (,$(call suitable-host-package,cmake,$(BR2_CMAKE)))
USE_SYSTEM_CMAKE = YES
else
BR2_CMAKE = $(HOST_DIR)/usr/bin/cmake
endif
