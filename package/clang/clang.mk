################################################################################
#
# clang
#
################################################################################

CLANG_VERSION = 4.0.0
CLANG_SITE = http://llvm.org/releases/$(CLANG_VERSION)
CLANG_SOURCE = cfe-$(CLANG_VERSION).src.tar.xz
CLANG_LICENSE = NCSA
CLANG_LICENSE_FILES = LICENSE.TXT

HOST_CLANG_DEPENDENCIES = host-llvm host-libxml2

CLANG_DEPENDENCIES = host-llvm host-libxml2 llvm

CLANG_SUPPORTS_IN_SOURCE_BUILD = NO

# * LLVM_INSTALL_TOOLCHAIN_ONLY
# * CLANG_ENABLE_BOOTSTRAP
# * LLVM_INCLUDE_TESTS
# * CLANG_RESOURCE_DIR
# * C_INCLUDE_DIRS
# * GCC_INSTALL_PREFIX
# * DEFAULT_SYSROOT
# * CLANG_DEFAULT_OPENMP_RUNTIME
# * CLANG_VENDOR
# * CLANG_REPOSITORY_STRING
# * CLANG_VENDOR_UTI
# * CLANG_ENABLE_ARCMT
# * CLANG_ENABLE_STATIC_ANALYZER
# * CLANG_INCLUDE_TESTS
# * CLANG_BUILD_EXAMPLES
HOST_CLANG_CONF_OPTS += -DLLVM_INCLUDE_TESTS=OFF \
	-DCLANG_INCLUDE_TESTS=OFF \
	-DCLANG_BUILD_EXAMPLES=OFF \
	-DCLANG_VENDOR=$(TARGET_VENDOR) \
	-DCLANG_VENDOR_UTI="http://bugs.buildroot.net/"

CLANG_CONF_ENV += LLVM_CONFIG=$(STAGING_DIR)/usr/bin/llvm-config

CLANG_CONF_OPTS += -DLLVM_INCLUDE_TESTS=OFF \
	-DCLANG_INCLUDE_TESTS=OFF \
	-DCLANG_BUILD_EXAMPLES=OFF \
	-DCLANG_BUILD_TOOLS=OFF \
	-DCLANG_INCLUDE_TESTS=OFF \
	-DCLANG_TABLEGEN=$(HOST_DIR)/usr/bin/llvm-tblgen \
	-DCLANG_VENDOR=$(TARGET_VENDOR) \
	-DCLANG_VENDOR_UTI="http://bugs.buildroot.net/"

#	-DLLVM_TOOLS_BINARY_DIR=$(HOST_DIR)/usr/bin \
	-DLLVM_LIBRARY_DIR=$(STAGING_DIR)/usr/lib \
	-DLLVM_MAIN_INCLUDE_DIR=$(STAGING_DIR)/usr/include \
	-DLLVM_MAIN_SRC_DIR=$(LLVM_DIR)/buildroot-build \
	-DLLVM_BINARY_DIR=$(STAGING_DIR)/usr \
	-DLLVM_TABLEGEN_EXE=$(HOST_DIR)/usr/bin/llvm-tblgen

# We need to set a proper RPATH otherwise the build stop on the RPATH check:
# *** ERROR: package host-clang installs executables without proper RPATH
# output/host/usr/bin/c-index-test
# output/host/usr/bin/clang-format
# output/host/usr/bin/clang-check
# output/host/usr/bin/clang-3.8
HOST_CLANG_CONF_ENV += \
	LDFLAGS="$(HOST_LDFLAGS) -L${HOST_DIR}/usr/lib -Wl,-rpath,${HOST_DIR}/usr/lib"

CLANG_CONF_ENV += \
	LDFLAGS="$(LDFLAGS) -L${STAGING_DIR}/usr/lib -Wl,-rpath,${STAGING_DIR}/usr/lib"

$(eval $(host-cmake-package))
$(eval $(cmake-package))
