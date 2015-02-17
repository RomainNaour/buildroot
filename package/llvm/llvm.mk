################################################################################
#
# llvm
#
################################################################################

LLVM_VERSION = 3.8.0
LLVM_SITE = http://llvm.org/releases/$(LLVM_VERSION)
LLVM_SOURCE = llvm-$(LLVM_VERSION).src.tar.xz
LLVM_LICENSE = University of Illinois/NCSA Open Source License
LLVM_LICENSE_FILES = LICENSE.TXT

LLVM_SUPPORTS_IN_SOURCE_BUILD = NO
#HOST_LLVM_INSTALL_STAGING = YES

# llvm is part of the toolchain so disable the toolchain dependency
HOST_LLVM_ADD_TOOLCHAIN_DEPENDENCY = NO

# http://llvm.org/docs/GettingStarted.html#software
# host-python: Python interpreter 2.7 or newer is required for builds and testing.
# host-zlib: Optional, adds compression / uncompression capabilities to selected LLVM tools.
HOST_LLVM_DEPENDENCIES = host-python host-zlib
# host-libtool: Shared library manager

# Use "Unix Makefiles" generator for generating make-compatible parallel makefiles.
# Ninja is not supported yet by Buildroot
HOST_LLVM_CONF_OPTS += -G "Unix Makefiles"

# * LLVM_INSTALL_UTILS: Include utility binaries in the 'install' target. OFF
#   Utils : FileCheck, KillTheDoctor, llvm-PerfectShuffle, count, not, count
# * LLVM_INSTALL_TOOLCHAIN_ONLY "Only include toolchain files in the 'install' target. OFF
#   We also want llvm livraries and modules.
# * LLVM_APPEND_VC_REV "Append the version control system revision id to LLVM version OFF
#   We build from a release archive without vcs
# * LLVM_LIBDIR_SUFFIX not used
#   We don't build a multilib toolchain
# * BUILD_SHARED_LIBS Build all libraries as shared libraries instead of static OFF
#   By default llvm build all libraries statically
# * LLVM_ENABLE_TIMESTAMPS: Enable embedding timestamp information in build ON
#   Turning it off is useful for deterministic builds.
# * LLVM_ENABLE_BACKTRACES: Enable embedding backtraces on crash ON
#   Use backtraces on crash to report toolchain issue.
# * ENABLE_CRASH_OVERRIDES: Enable crash overrides ON
#   Keep the possibility to install or overrides signal handlers
# * LLVM_ENABLE_FFI: Use libffi to call external functions from the interpreter OFF
#   Keep ffi disabled for now
# * LLVM_ENABLE_TERMINFO: Use terminfo database if available. ON
#   Keep terminfo database enabled
# * LLVM_ENABLE_THREADS: Use threads if available ON
#   Keep threads enabled
# * LLVM_ENABLE_ZLIB: Use zlib for compression/decompression if available ON
#   Keep zlib support enabled
# * LLVM_ENABLE_PIC: Build Position-Independent Code ON
#   We don't use llvm for static only build, so enable PIC
# * LLVM_ENABLE_WARNINGS: Enable compiler warnings ON
#   Keep compiler warning enabled
# * LLVM_ENABLE_PEDANTIC: Compile with pedantic enabled ON
#   Keep pedantic enabled
# * LLVM_ENABLE_WERROR: Fail and stop if a warning is triggered OFF
#   Keep Werror disabled
# * CMAKE_BUILD_TYPE: Set build type Debug, Release, RelWithDebInfo, and MinSizeRel.
#   Default is Debug. Use the Release build which requires considerably less space.
# * WITH_POLLY: Build LLVM with Polly ON
#   Keep it enabled
# * LINK_POLLY_INTO_TOOLS: Static link Polly into tools OFF
#   Don't link polly statically
# * LLVM_INCLUDE_TOOLS: Generate build targets for the LLVM tools ON
#   Build llvm tools for the target
# * LLVM_BUILD_TOOLS: Build the LLVM tools for the host ON
#   Build llvm tools for the host
# * LLVM_INCLUDE_UTILS: Generate build targets for the LLVM utils ON
#   Disabled, since we don't install them to the target.
# * LLVM_BUILD_RUNTIME: Build the LLVM runtime libraries ON
#   Keep llvm runtime livraries
# * LLVM_BUILD_EXAMPLES: Build the LLVM example programs OFF
#   Don't build examples
# * LLVM_BUILD_TESTS: Build LLVM unit tests OFF
#   Don't build tests
# * LLVM_INCLUDE_TESTS: Generate build targets for the LLVM unit tests ON
#   Don't build llvm unit tests
# * LLVM_INCLUDE_GO_TESTS: Include the Go bindings tests in test build targets ON
#   Don't build Go tests
# * LLVM_BUILD_DOCS: Build the llvm documentation OFF
#   Disable llvm documentation
# * LLVM_INCLUDE_DOCS: Generate build targets for llvm documentation ON
#   Don't build llvm documentation
# * LLVM_ENABLE_DOXYGEN: Use doxygen to generate llvm API documentation OFF
#   Don't build llvm API documentation
# * LLVM_ENABLE_SPHINX: Use Sphinx to generate llvm documentation OFF
#   Don't build llvm documentation
# * LLVM_BUILD_EXTERNAL_COMPILER_RT: Build compiler-rt as an external project OFF
#   Keep rt compiler disabled
HOST_LLVM_CONF_OPTS += -DLLVM_INSTALL_UTILS=OFF \
	-DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF \
	-DLLVM_APPEND_VC_REV=OFF \
	-DBUILD_SHARED_LIBS=OFF \
	-DLLVM_ENABLE_TIMESTAMPS=OFF \
	-DLLVM_ENABLE_BACKTRACES=ON \
	-DENABLE_CRASH_OVERRIDES=ON \
	-DLLVM_ENABLE_FFI=OFF \
	-DLLVM_ENABLE_TERMINFO=ON \
	-DLLVM_ENABLE_THREADS=ON \
	-DLLVM_ENABLE_ZLIB=ON \
	-DLLVM_ENABLE_PIC=ON \
	-DLLVM_ENABLE_WARNINGS=ON \
	-DLLVM_ENABLE_PEDANTIC=ON \
	-DLLVM_ENABLE_WERROR=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	-DWITH_POLLY=ON \
	-DLLVM_INCLUDE_TOOLS=ON \
	-DLLVM_BUILD_TOOLS=ON \
	-DLLVM_INCLUDE_UTILS=OFF \
	-DLLVM_BUILD_RUNTIME=ON \
	-DLLVM_BUILD_EXAMPLES=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF \
	-DLLVM_BUILD_TESTS=OFF \
	-DLLVM_INCLUDE_TESTS=OFF \
	-DLLVM_INCLUDE_GO_TESTS=OFF \
	-DLLVM_BUILD_DOCS=OFF \
	-DLLVM_INCLUDE_DOCS=OFF \
	-DLLVM_ENABLE_DOXYGEN=OFF \
	-DLLVM_ENABLE_SPHINX=OFF \
	-DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF

# Semicolon-separated list of targets to build, or \"all\"
# LLVM_ALL_TARGETS AArch64 AMDGPU ARM BPF CppBackend Hexagon Mips MSP430
# NVPTX PowerPC Sparc SystemZ X86 XCore
# List of targets with JIT support:
#set(LLVM_TARGETS_WITH_JIT X86 PowerPC AArch64 ARM Mips SystemZ)
ifeq ($(BR2_aarch64),y)
HOST_LLVM_CONF_OPTS += -DLLVM_TARGETS_TO_BUILD="AArch64" \
	-DLLVM_TARGET_ARCH="AArch64"
else ifeq ($(BR2_arm),y)
HOST_LLVM_CONF_OPTS += -DLLVM_TARGETS_TO_BUILD="ARM" \
	-DLLVM_TARGET_ARCH="ARM"
else ifeq ($(BR2_i386)$(BR2_x86_64),y)
HOST_LLVM_CONF_OPTS += -DLLVM_TARGETS_TO_BUILD="X86" \
	-DLLVM_TARGET_ARCH="X86"
endif

# * LLVM_ENABLE_MODULES: Compile with C++ modules enabled OFF
#   Disabled, requires sys/ndir.h header
# * LLVM_ENABLE_CXX1Y: Compile with C++1y enabled OFF
#   Enable C++ and C++11 support if BR2_INSTALL_LIBSTDCPP=y
# * LLVM_ENABLE_LIBCXX: Use libc++ if available OFF
#   Use -stdlib=libc++ compiler flag, use libc++ as C++ standard library
# * LLVM_ENABLE_LIBCXXABI: Use libc++abi when using libc++
#   Append -lc++abi to compiler flags
# http://libcxx.llvm.org/
ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_MODULES=OFF \
	-DLLVM_ENABLE_CXX1Y=ON \
	-DLLVM_ENABLE_LIBCXX=OFF \
	-DLLVM_ENABLE_LIBCXXABI=OFF
endif

# * LLVM_DEFAULT_TARGET_TRIPLE: By default, we target the host, but this can be overridden at CMake
# invocation time.

$(eval $(host-cmake-package))
