################################################################################
#
# llvm
#
################################################################################

LLVM_VERSION = 4.0.1
LLVM_SITE = http://llvm.org/releases/$(LLVM_VERSION)
LLVM_SOURCE = llvm-$(LLVM_VERSION).src.tar.xz
LLVM_LICENSE = NCSA
LLVM_LICENSE_FILES = LICENSE.TXT

LLVM_SUPPORTS_IN_SOURCE_BUILD = NO

# http://llvm.org/docs/GettingStarted.html#software
# host-python: Python interpreter 2.7 or newer is required for builds and testing.
# host-zlib: Optional, adds compression / uncompression capabilities to selected LLVM tools.
HOST_LLVM_DEPENDENCIES = host-python host-zlib
# host-libtool: Shared library manager

# Use "Unix Makefiles" generator for generating make-compatible parallel makefiles.
# Ninja is not supported yet by Buildroot
HOST_LLVM_CONF_OPTS += -G "Unix Makefiles"

# * LLVM_BUILD_UTILS: Build LLVM utility binaries. If OFF, just generate build targets.
#   Keep llvm utility binaries.
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_UTILS=ON

# * LLVM_INSTALL_UTILS: Include utility binaries in the 'install' target. OFF
#   Utils : FileCheck, KillTheDoctor, llvm-PerfectShuffle, count, not, yaml-bench
HOST_LLVM_CONF_OPTS += -DLLVM_INSTALL_UTILS=OFF

# * LLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING:
#   Disable abi-breaking checks mismatch detection at link-tim
#   Keep it enabled
HOST_LLVM_CONF_OPTS += -DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=OFF

# * LLVM_ENABLE_LIBEDIT: Use libedit if available
#   Disabled since no host-libedit
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_LIBEDIT=OFF

# * LLVM_INSTALL_TOOLCHAIN_ONLY "Only include toolchain files in the 'install' target. OFF
#   We also want llvm libraries and modules.
HOST_LLVM_CONF_OPTS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

# * LLVM_APPEND_VC_REV "Append the version control system revision id to LLVM version OFF
#   We build from a release archive without vcs
HOST_LLVM_CONF_OPTS += -DLLVM_APPEND_VC_REV=OFF

# * BUILD_SHARED_LIBS Build all libraries as shared libraries instead of static ON
#   BUILD_SHARED_LIBS is only recommended for use by LLVM developers.
#   If you want to build LLVM as a shared library, you should use the
#   LLVM_BUILD_LLVM_DYLIB option.
HOST_LLVM_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF

# * LLVM_ENABLE_BACKTRACES: Enable embedding backtraces on crash ON
#   Use backtraces on crash to report toolchain issue.
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_BACKTRACES=ON

# * ENABLE_CRASH_OVERRIDES: Enable crash overrides ON
#   Keep the possibility to install or overrides signal handlers
HOST_LLVM_CONF_OPTS += -DENABLE_CRASH_OVERRIDES=ON

# * LLVM_ENABLE_FFI: Use libffi to call external functions from the interpreter OFF
#   Keep ffi disabled for now
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_FFI=OFF

# * LLVM_ENABLE_TERMINFO: Use terminfo database if available. ON
#   Disable terminfo database (needs ncurses libtinfo.so)
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_TERMINFO=OFF
LLVM_CONF_OPTS += -DLLVM_ENABLE_TERMINFO=OFF

# * LLVM_ENABLE_THREADS: Use threads if available ON
#   Keep threads enabled
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_THREADS=ON

# * LLVM_ENABLE_ZLIB: Use zlib for compression/decompression if available ON
#   Keep zlib support enabled
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_ZLIB=ON

# * LLVM_ENABLE_PIC: Build Position-Independent Code ON
#   We don't use llvm for static only build, so enable PIC
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_PIC=ON

# * LLVM_ENABLE_WARNINGS: Enable compiler warnings ON
#   Keep compiler warning enabled
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_WARNINGS=ON

# * LLVM_ENABLE_PEDANTIC: Compile with pedantic enabled ON
#   Keep pedantic enabled
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_PEDANTIC=ON

# * LLVM_ENABLE_WERROR: Fail and stop if a warning is triggered OFF
#   Keep Werror disabled
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_WERROR=OFF

# * CMAKE_BUILD_TYPE: Set build type Debug, Release, RelWithDebInfo, and MinSizeRel.
#   Default is Debug. Use the Release build which requires considerably less space.
HOST_LLVM_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

# * LLVM_POLLY_BUILD: Build LLVM with Polly ON
#   Keep it enabled
HOST_LLVM_CONF_OPTS += -DLLVM_POLLY_BUILD=ON

# * LINK_POLLY_INTO_TOOLS: Static link Polly into tools ON
HOST_LLVM_CONF_OPTS += -DLLVM_POLLY_LINK_INTO_TOOLS=ON

# * LLVM_INCLUDE_TOOLS: Generate build targets for the LLVM tools ON
#   Build llvm tools for the target
HOST_LLVM_CONF_OPTS += -DLLVM_INCLUDE_TOOLS=ON

# * LLVM_BUILD_TOOLS: Build the LLVM tools for the host ON
#   Build llvm tools for the host
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_TOOLS=ON

# * LLVM_INCLUDE_UTILS: Generate build targets for the LLVM utils ON
#   Disabled, since we don't install them to the target.
HOST_LLVM_CONF_OPTS += -DLLVM_INCLUDE_UTILS=OFF

# * LLVM_BUILD_RUNTIME: Build the LLVM runtime libraries ON
#   Keep llvm runtime livraries
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_RUNTIME=ON

# * LLVM_BUILD_EXAMPLES: Build the LLVM example programs OFF
#   Don't build examples
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_EXAMPLES=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF

# * LLVM_BUILD_TESTS: Build LLVM unit tests OFF
#   Don't build tests
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_TESTS=OFF

# * LLVM_INCLUDE_TESTS: Generate build targets for the LLVM unit tests ON
#   Don't build llvm unit tests
HOST_LLVM_CONF_OPTS += -DLLVM_INCLUDE_TESTS=OFF

# * LLVM_INCLUDE_GO_TESTS: Include the Go bindings tests in test build targets ON
#   Don't build Go tests
HOST_LLVM_CONF_OPTS += -DLLVM_INCLUDE_GO_TESTS=OFF

# * LLVM_BUILD_DOCS: Build the llvm documentation OFF
#   Disable llvm documentation
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_DOCS=OFF

# * LLVM_INCLUDE_DOCS: Generate build targets for llvm documentation ON
#   Don't build llvm documentation
HOST_LLVM_CONF_OPTS += -DLLVM_INCLUDE_DOCS=OFF

# * LLVM_ENABLE_DOXYGEN: Use doxygen to generate llvm API documentation OFF
#   Don't build llvm API documentation
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_DOXYGEN=OFF

# * LLVM_ENABLE_SPHINX: Use Sphinx to generate llvm documentation OFF
#   Don't build llvm documentation
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_SPHINX=OFF

# * LLVM_ENABLE_OCAMLDOC: Use OCaml bindings documentation OFF
#   Don't build llvm documentation
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_OCAMLDOC=OFF

# * LLVM_BUILD_EXTERNAL_COMPILER_RT: Build compiler-rt as an external project OFF
#   Keep rt compiler disabled
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF

HOST_LLVM_TARGET_ARCH = $(call qstrip,$(BR2_PACKAGE_LLVM_TARGET_ARCH))
HOST_LLVM_CONF_OPTS += -DLLVM_TARGETS_TO_BUILD=$(HOST_LLVM_TARGET_ARCH)
# LLVM target to use for native code generation.
HOST_LLVM_CONF_OPTS += -DLLVM_TARGET_ARCH=$(HOST_LLVM_TARGET_ARCH)

# * LLVM_ENABLE_CXX1Y: Compile with C++1y enabled OFF
#   Enable C++ and C++11 support if BR2_INSTALL_LIBSTDCPP=y
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_CXX1Y=$(if $(BR2_INSTALL_LIBSTDCPP),ON,OFF)

# * LLVM_ENABLE_MODULES: Compile with C++ modules enabled OFF
#   Disabled, requires sys/ndir.h header
#   Disable debug in module
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_MODULES=OFF \
	-DLLVM_ENABLE_MODULE_DEBUGGING=OFF

# * LLVM_ENABLE_LIBCXX: Use libc++ if available OFF
#   Use -stdlib=libc++ compiler flag, use libc++ as C++ standard library
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_LIBCXX=OFF

# * LLVM_ENABLE_LLD: Use lld as C and C++ linker. OFF
HOST_LLVM_CONF_OPTS += -DLLVM_ENABLE_LLD=OFF

# * LLVM_DEFAULT_TARGET_TRIPLE: By default, we target the host, but this can be overridden at CMake
# invocation time.
HOST_LLVM_CONF_OPTS += -DLLVM_DEFAULT_TARGET_TRIPLE=$(GNU_TARGET_NAME)

# The Go bindings have no CMake rules at the moment, but better remove the
# check preventively. Building the Go and OCaml bindings is yet unsupported.
HOST_LLVM_CONF_OPTS += \
	-DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND \
	-DOCAMLFIND=OCAMLFIND-NOTFOUND

# Builds a release tablegen that gets used during the LLVM build.
HOST_LLVM_CONF_OPTS += -DLLVM_OPTIMIZED_TABLEGEN=ON

# Generate libLLVM.so. This library contains a default set of LLVM components
# that can be overridden with "LLVM_DYLIB_COMPONENTS". The default contains
# most of LLVM and is defined in "tools/llvm-shlib/CMakelists.txt".
HOST_LLVM_CONF_OPTS += -DLLVM_BUILD_LLVM_DYLIB=ON

$(eval $(cmake-package))
$(eval $(host-cmake-package))
