################################################################################
#
# llvm
#
################################################################################

LLVM_VERSION = 4.0.0
LLVM_SITE = http://llvm.org/releases/$(LLVM_VERSION)
LLVM_SOURCE = llvm-$(LLVM_VERSION).src.tar.xz
LLVM_LICENSE = NCSA
LLVM_LICENSE_FILES = LICENSE.TXT

LLVM_SUPPORTS_IN_SOURCE_BUILD = NO
LLVM_INSTALL_STAGING = YES

# http://llvm.org/docs/GettingStarted.html#software
# host-python: Python interpreter 2.7 or newer is required for builds and testing.
# host-zlib: Optional, adds compression / uncompression capabilities to selected LLVM tools.
HOST_LLVM_DEPENDENCIES = host-python host-zlib
# host-libtool: Shared library manager

LLVM_DEPENDENCIES = host-llvm zlib

LLVM_CONF_OPTS += -DLLVM_TABLEGEN=$(HOST_DIR)/usr/bin/llvm-tblgen

# Use "Unix Makefiles" generator for generating make-compatible parallel makefiles.
# Ninja is not supported yet by Buildroot
HOST_LLVM_CONF_OPTS += -G "Unix Makefiles"
LLVM_CONF_OPTS += -G "Unix Makefiles"

# * LLVM_BUILD_UTILS: Build LLVM utility binaries. If OFF, just generate build targets.
#   Keep llvm utility binaries for the host.
#   For the target, we should disable it but setting LLVM_BUILD_UTILS=OFF and
#   LLVM_INSTALL_UTILS=OFF together break the install step due to undefined cmake
#   behavior: "Target "llvm-tblgen" has EXCLUDE_FROM_ALL set and will not be built by
#   default but an install rule has been provided for it.  CMake does not define behavior
#   for this case."
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_UTILS=ON
LLVM_CONF_OPTS += -DLLVM_BUILD_UTILS=ON

# * LLVM_INSTALL_UTILS: Include utility binaries in the 'install' target. OFF
#   Utils : FileCheck, KillTheDoctor, llvm-PerfectShuffle, count, not, count
HOST_LLVM_CONF_OPTS += -DLLVM_INSTALL_UTILS=OFF
LLVM_CONF_OPTS += -DLLVM_INSTALL_UTILS=OFF

# * LLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING:
#   Disable abi-breaking checks mismatch detection at link-tim
#   Keep it enabled
HOST_LLVM_CONF_OPTS += -DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=OFF
LLVM_CONF_OPTS += -DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=OFF

# * LLVM_ENABLE_LIBEDIT: Use libedit if available
#   Disabled since no host-libedit
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_LIBEDIT=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_LIBEDIT=OFF

# * LLVM_INSTALL_TOOLCHAIN_ONLY "Only include toolchain files in the 'install' target. OFF
#   We also want llvm livraries and modules.
HOST_LLVM_CONF_OPTS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF
LLVM_CONF_OPTS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

# * LLVM_APPEND_VC_REV "Append the version control system revision id to LLVM version OFF
#   We build from a release archive without vcs
HOST_LLVM_CONF_OPTS += -DLLVM_APPEND_VC_REV=OFF
LLVM_CONF_OPTS += -DLLVM_APPEND_VC_REV=OFF

# * LLVM_LIBDIR_SUFFIX not used
#   We don't build a multilib toolchain

# * BUILD_SHARED_LIBS Build all libraries as shared libraries instead of static ON
#   Needed for mesa3d --enable-llvm-shared-libs option
HOST_LLVM_CONF_OPTS += -DBUILD_SHARED_LIBS=ON
LLVM_CONF_OPTS += -DBUILD_SHARED_LIBS=ON

# * LLVM_ENABLE_BACKTRACES: Enable embedding backtraces on crash ON
#   Use backtraces on crash to report toolchain issue.
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_BACKTRACES=ON
LLVM_CONF_OPTS += -DLLVM_ENABLE_BACKTRACES=ON

# * ENABLE_CRASH_OVERRIDES: Enable crash overrides ON
#   Keep the possibility to install or overrides signal handlers
HOST_LLVM_CONF_OPTS += -DENABLE_CRASH_OVERRIDES=ON
LLVM_CONF_OPTS += -DENABLE_CRASH_OVERRIDES=ON

# * LLVM_ENABLE_FFI: Use libffi to call external functions from the interpreter OFF
#   Keep ffi disabled for now
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_FFI=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_FFI=OFF

# * LLVM_ENABLE_TERMINFO: Use terminfo database if available. ON
#   Disable terminfo database (needs ncurses libtinfo.so)
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_TERMINFO=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_TERMINFO=OFF

# * LLVM_ENABLE_THREADS: Use threads if available ON
#   Keep threads enabled
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_THREADS=ON
LLVM_CONF_OPTS += -DLLVM_ENABLE_THREADS=ON

# * LLVM_ENABLE_ZLIB: Use zlib for compression/decompression if available ON
#   Keep zlib support enabled
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_ZLIB=ON
LLVM_CONF_OPTS += -DLLVM_ENABLE_ZLIB=ON

# * LLVM_ENABLE_PIC: Build Position-Independent Code ON
#   We don't use llvm for static only build, so enable PIC
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_PIC=ON
LLVM_CONF_OPTS += -DLLVM_ENABLE_PIC=ON

# * LLVM_ENABLE_WARNINGS: Enable compiler warnings ON
#   Keep compiler warning enabled
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_WARNINGS=ON
LLVM_CONF_OPTS += -DLLVM_ENABLE_WARNINGS=ON

# * LLVM_ENABLE_PEDANTIC: Compile with pedantic enabled ON
#   Keep pedantic enabled
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_PEDANTIC=ON
LLVM_CONF_OPTS += -DLLVM_ENABLE_PEDANTIC=ON

# * LLVM_ENABLE_WERROR: Fail and stop if a warning is triggered OFF
#   Keep Werror disabled
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_WERROR=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_WERROR=OFF

# * CMAKE_BUILD_TYPE: Set build type Debug, Release, RelWithDebInfo, and MinSizeRel.
#   Default is Debug. Use the Release build which requires considerably less space.
HOST_LLVM_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
LLVM_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

# * LLVM_POLLY_BUILD: Build LLVM with Polly ON
#   Keep it enabled
HOST_LLVM_CONF_OPTS += -DLLVM_POLLY_BUILD=ON
LLVM_CONF_OPTS += -DLLVM_POLLY_BUILD=ON

# * LINK_POLLY_INTO_TOOLS: Static link Polly into tools ON
HOST_LLVM_CONF_OPTS += -DLLVM_POLLY_LINK_INTO_TOOLS=ON
LLVM_CONF_OPTS += -DLLVM_POLLY_LINK_INTO_TOOLS=OFF

# * LLVM_INCLUDE_TOOLS: Generate build targets for the LLVM tools ON
#   Build llvm tools for the target
HOST_LLVM_CONF_OPTS += -DLLVM_INCLUDE_TOOLS=ON
LLVM_CONF_OPTS += -DLLVM_INCLUDE_TOOLS=OFF

# * LLVM_BUILD_TOOLS: Build the LLVM tools for the host ON
#   Build llvm tools for the host
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_TOOLS=ON
LLVM_CONF_OPTS += -DLLVM_BUILD_TOOLS=OFF

# * LLVM_INCLUDE_UTILS: Generate build targets for the LLVM utils ON
#   Disabled, since we don't install them to the target.
HOST_LLVM_CONF_OPTS += -DLLVM_INCLUDE_UTILS=OFF
LLVM_CONF_OPTS += -DLLVM_INCLUDE_UTILS=OFF

# * LLVM_BUILD_RUNTIME: Build the LLVM runtime libraries ON
#   Keep llvm runtime livraries
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_RUNTIME=ON
LLVM_CONF_OPTS += -DLLVM_BUILD_RUNTIME=ON

# * LLVM_BUILD_EXAMPLES: Build the LLVM example programs OFF
#   Don't build examples
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_EXAMPLES=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF
LLVM_CONF_OPTS += -DLLVM_BUILD_EXAMPLES=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF

# * LLVM_BUILD_TESTS: Build LLVM unit tests OFF
#   Don't build tests
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_TESTS=OFF
LLVM_CONF_OPTS += -DLLVM_BUILD_TESTS=OFF

# * LLVM_INCLUDE_TESTS: Generate build targets for the LLVM unit tests ON
#   Don't build llvm unit tests
HOST_LLVM_CONF_OPTS += -DLLVM_INCLUDE_TESTS=OFF
LLVM_CONF_OPTS += -DLLVM_INCLUDE_TESTS=OFF

# * LLVM_INCLUDE_GO_TESTS: Include the Go bindings tests in test build targets ON
#   Don't build Go tests
HOST_LLVM_CONF_OPTS += -DLLVM_INCLUDE_GO_TESTS=OFF
LLVM_CONF_OPTS += -DLLVM_INCLUDE_GO_TESTS=OFF

# * LLVM_BUILD_DOCS: Build the llvm documentation OFF
#   Disable llvm documentation
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_DOCS=OFF
LLVM_CONF_OPTS += -DLLVM_BUILD_DOCS=OFF

# * LLVM_INCLUDE_DOCS: Generate build targets for llvm documentation ON
#   Don't build llvm documentation
HOST_LLVM_CONF_OPTS += -DLLVM_INCLUDE_DOCS=OFF
LLVM_CONF_OPTS += -DLLVM_INCLUDE_DOCS=OFF

# * LLVM_ENABLE_DOXYGEN: Use doxygen to generate llvm API documentation OFF
#   Don't build llvm API documentation
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_DOXYGEN=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_DOXYGEN=OFF

# * LLVM_ENABLE_SPHINX: Use Sphinx to generate llvm documentation OFF
#   Don't build llvm documentation
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_SPHINX=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_SPHINX=OFF

# * LLVM_ENABLE_OCAMLDOC: Use OCaml bindings documentation OFF
#   Don't build llvm documentation
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_OCAMLDOC=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_OCAMLDOC=OFF

# * LLVM_BUILD_EXTERNAL_COMPILER_RT: Build compiler-rt as an external project OFF
#   Keep rt compiler disabled
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF
LLVM_CONF_OPTS += -DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF

# Semicolon-separated list of targets to build, or \"all\"
HOST_LLVM_CONF_OPTS += -DLLVM_TARGETS_TO_BUILD="all"
LLVM_CONF_OPTS += -DLLVM_TARGETS_TO_BUILD="all"

# LLVM_ALL_TARGETS AArch64 AMDGPU ARM BPF CppBackend Hexagon Mips MSP430
# NVPTX PowerPC Sparc SystemZ X86 XCore
# List of targets with JIT support:
#set(LLVM_TARGETS_WITH_JIT X86 PowerPC AArch64 ARM Mips SystemZ)
ifeq ($(BR2_aarch64),y)
HOST_LLVM_CONF_OPTS += -DLLVM_TARGET_ARCH="AArch64"
LLVM_CONF_OPTS += -DLLVM_TARGET_ARCH="AArch64"
else ifeq ($(BR2_arm),y)
HOST_LLVM_CONF_OPTS += -DLLVM_TARGET_ARCH="ARM"
LLVM_CONF_OPTS += -DLLVM_TARGET_ARCH="ARM"
else ifeq ($(BR2_i386)$(BR2_x86_64),y)
HOST_LLVM_CONF_OPTS += -DLLVM_TARGET_ARCH="X86"
LLVM_CONF_OPTS += -DLLVM_TARGET_ARCH="X86"
endif

# * LLVM_ENABLE_CXX1Y: Compile with C++1y enabled OFF
#   Enable C++ and C++11 support if BR2_INSTALL_LIBSTDCPP=y
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_CXX1Y=$(if $(BR2_INSTALL_LIBSTDCPP),ON,OFF)
LLVM_CONF_OPTS += -DLLVM_ENABLE_CXX1Y=$(if $(BR2_INSTALL_LIBSTDCPP),ON,OFF)

# * LLVM_ENABLE_MODULES: Compile with C++ modules enabled OFF
#   Disabled, requires sys/ndir.h header
#   Disable debug in module
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_MODULES=OFF \
	-DLLVM_ENABLE_MODULE_DEBUGGING=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_MODULES=OFF \
	-DLLVM_ENABLE_MODULE_DEBUGGING=OFF

# * LLVM_ENABLE_LIBCXX: Use libc++ if available OFF
#   Use -stdlib=libc++ compiler flag, use libc++ as C++ standard library
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_LIBCXX=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_LIBCXX=OFF

# * LLVM_ENABLE_LLD: Use lld as C and C++ linker. OFF
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_LLD=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_LLD=OFF

# * LLVM_DEFAULT_TARGET_TRIPLE: By default, we target the host, but this can be overridden at CMake
# invocation time.

$(eval $(host-cmake-package))
$(eval $(cmake-package))
