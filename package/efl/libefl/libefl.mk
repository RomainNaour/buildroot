################################################################################
#
# libefl
#
################################################################################

LIBEFL_VERSION = $(EFL_VERSION)
LIBEFL_SOURCE = efl-$(LIBEFL_VERSION).tar.xz
LIBEFL_SITE = http://download.enlightenment.org/rel/libs/efl
LIBEFL_LICENSE = BSD-2c, LGPLv2.1+, GPLv2+
LIBEFL_LICENSE_FILES = \
	COMPLIANCE \
	COPYING \
	licenses/COPYING.BSD \
	licenses/COPYING.FTL \
	licenses/COPYING.GPL \
	licenses/COPYING.LGPL \
	licenses/COPYING.SMALL

LIBEFL_INSTALL_STAGING = YES

LIBEFL_DEPENDENCIES = host-pkgconf host-libefl dbus freetype jpeg lua udev \
	util-linux zlib

# Regenerate the autotools:
#  - to fix an issue in eldbus-codegen: https://phab.enlightenment.org/T2718
#  - to remove dependency on libXp: https://phab.enlightenment.org/D3150
LIBEFL_AUTORECONF = YES
LIBEFL_GETTEXTIZE = YES

# Configure options:
# --disable-cxx-bindings: disable C++11 bindings.
# --disable-sdl: disable sdl2 support.
# --enable-lua-old: disable Elua and remove luajit dependency.
# --with-opengl=none: disable opengl support.
# --with-x11=none: remove dependency on X.org.
LIBEFL_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eolian-gen=$(HOST_DIR)/usr/bin/eolian_gen \
	--disable-cxx-bindings \
	--disable-sdl \
	--enable-lua-old

# Disable untested configuration warning.
ifeq ($(BR2_PACKAGE_LIBEFL_RECOMMENDED_CONFIG),)
LIBEFL_CONF_OPTS += --enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),y)
LIBEFL_DEPENDENCIES += util-linux
LIBEFL_CONF_OPTS += --enable-libmount
else
LIBEFL_CONF_OPTS += --disable-libmount
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
LIBEFL_CONF_OPTS += --enable-systemd
LIBEFL_DEPENDENCIES += systemd
else
LIBEFL_CONF_OPTS += --disable-systemd
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
LIBEFL_CONF_OPTS += --enable-fontconfig
LIBEFL_DEPENDENCIES += fontconfig
else
LIBEFL_CONF_OPTS += --disable-fontconfig
endif

ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
LIBEFL_CONF_OPTS += --enable-fribidi
LIBEFL_DEPENDENCIES += libfribidi
else
LIBEFL_CONF_OPTS += --disable-fribidi
endif

ifeq ($(BR2_PACKAGE_GSTREAMER1)$(BR2_PACKAGE_GST1_PLUGINS_BASE),yy)
LIBEFL_CONF_OPTS += --enable-gstreamer1
LIBEFL_DEPENDENCIES += gstreamer1 gst1-plugins-base
else
LIBEFL_CONF_OPTS += --disable-gstreamer1
endif

ifeq ($(BR2_PACKAGE_BULLET),y)
LIBEFL_CONF_OPTS += --enable-physics
LIBEFL_DEPENDENCIES += bullet
else
LIBEFL_CONF_OPTS += --disable-physics
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
LIBEFL_CONF_OPTS += --enable-audio
LIBEFL_DEPENDENCIES += libsndfile
else
LIBEFL_CONF_OPTS += --disable-audio
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
LIBEFL_CONF_OPTS += --enable-pulseaudio
LIBEFL_DEPENDENCIES += pulseaudio
else
LIBEFL_CONF_OPTS += --disable-pulseaudio
endif

ifeq ($(BR2_PACKAGE_HARFBUZZ),y)
LIBEFL_DEPENDENCIES += harfbuzz
LIBEFL_CONF_OPTS += --enable-harfbuzz
else
LIBEFL_CONF_OPTS += --disable-harfbuzz
endif

ifeq ($(BR2_PACKAGE_TSLIB),y)
LIBEFL_DEPENDENCIES += tslib
LIBEFL_CONF_OPTS += --enable-tslib
else
LIBEFL_CONF_OPTS += --disable-tslib
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
LIBEFL_DEPENDENCIES += libglib2
LIBEFL_CONF_OPTS += --with-glib=yes
else
LIBEFL_CONF_OPTS += --with-glib=no
endif

# Prefer openssl (the default) over gnutls.
ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBEFL_DEPENDENCIES += openssl
LIBEFL_CONF_OPTS += --with-crypto=openssl
else ifeq ($(BR2_PACKAGE_GNUTLS)$(BR2_PACKAGE_LIBGCRYPT),yy)
LIBEFL_DEPENDENCIES += gnutls libgcrypt
LIBEFL_CONF_OPTS += --with-crypto=gnutls \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
LIBEFL_CONF_OPTS += --with-crypto=none
endif # BR2_PACKAGE_OPENSSL

ifeq ($(BR2_PACKAGE_WAYLAND),y)
LIBEFL_DEPENDENCIES += wayland libxkbcommon
LIBEFL_CONF_OPTS += --enable-wayland
else
LIBEFL_CONF_OPTS += --disable-wayland
endif

ifeq ($(BR2_PACKAGE_LIBEFL_FB),y)
LIBEFL_CONF_OPTS += --enable-fb
else
LIBEFL_CONF_OPTS += --disable-fb
endif

ifeq ($(BR2_PACKAGE_LIBEFL_X_XLIB),y)
# --enable-xinput22 is recommended
LIBEFL_CONF_OPTS += --with-x=$(STAGING_DIR) \
	--with-x11=xlib \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	--enable-xinput22

LIBEFL_DEPENDENCIES += \
	xlib_libX11 \
	xlib_libXcomposite \
	xlib_libXcursor \
	xlib_libXdamage \
	xlib_libXext \
	xlib_libXi \
	xlib_libXinerama \
	xlib_libXrandr \
	xlib_libXrender \
	xlib_libXScrnSaver \
	xlib_libXtst
else
LIBEFL_CONF_OPTS += --with-x11=none
endif

ifeq ($(BR2_PACKAGE_LIBEFL_OPENGL),y)
LIBEFL_CONF_OPTS += --with-opengl=full
LIBEFL_DEPENDENCIES += libgl
endif

ifeq ($(BR2_PACKAGE_LIBEFL_OPENGLES),y)
LIBEFL_CONF_OPTS += --with-opengl=es
LIBEFL_DEPENDENCIES += libgles
endif

ifeq ($(BR2_PACKAGE_LIBEFL_OPENGL_NONE),y)
LIBEFL_CONF_OPTS += --with-opengl=none
endif

# Loaders that need external dependencies needs to be --enable-XXX=yes
# otherwise the default is '=static'.
# All other loaders are statically built-in
ifeq ($(BR2_PACKAGE_LIBEFL_PNG),y)
LIBEFL_CONF_OPTS += --enable-image-loader-png=yes
LIBEFL_DEPENDENCIES += libpng
else
LIBEFL_CONF_OPTS += --disable-image-loader-png
endif

ifeq ($(BR2_PACKAGE_LIBEFL_JPEG),y)
LIBEFL_CONF_OPTS += --enable-image-loader-jpeg=yes
# libefl already depends on jpeg.
else
LIBEFL_CONF_OPTS += --disable-image-loader-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBEFL_GIF),y)
LIBEFL_CONF_OPTS += --enable-image-loader-gif=yes
LIBEFL_DEPENDENCIES += giflib
else
LIBEFL_CONF_OPTS += --disable-image-loader-gif
endif

ifeq ($(BR2_PACKAGE_LIBEFL_TIFF),y)
LIBEFL_CONF_OPTS += --enable-image-loader-tiff=yes
LIBEFL_DEPENDENCIES += tiff
else
LIBEFL_CONF_OPTS += --disable-image-loader-tiff
endif

ifeq ($(BR2_PACKAGE_LIBEFL_JP2K),y)
LIBEFL_CONF_OPTS += --enable-image-loader-jp2k=yes
LIBEFL_DEPENDENCIES += openjpeg
else
LIBEFL_CONF_OPTS += --disable-image-loader-jp2k
endif

ifeq ($(BR2_PACKAGE_LIBEFL_WEBP),y)
LIBEFL_CONF_OPTS += --enable-image-loader-webp=yes
LIBEFL_DEPENDENCIES += webp
else
LIBEFL_CONF_OPTS += --disable-image-loader-webp
endif

$(eval $(autotools-package))

################################################################################
#
# host-libefl
#
################################################################################

# We want to build only some host tools used later in the build.
# Actually we want: edje_cc, embryo_cc and eet.

# Host dependencies:
# * host-dbus: for Eldbus
# * host-freetype: for libevas
# * host-libglib2: for libecore
# * host-libjpeg, host-libpng: for libevas image loader
# * host-lua: disable luajit dependency
HOST_LIBEFL_DEPENDENCIES = \
	host-pkgconf \
	host-dbus \
	host-freetype \
	host-libglib2 \
	host-libjpeg \
	host-libpng \
	host-lua \
	host-zlib

# Configure options:
# --disable-audio, --disable-multisense remove libsndfile dependency.
# --disable-cxx-bindings: disable C++11 bindings.
# --disable-fontconfig: remove dependency on fontconfig.
# --disable-fribidi: remove dependency on libfribidi.
# --disable-gstreamer1: remove dependency on gtreamer 1.0.
# --disable-libeeze: remove libudev dependency.
# --disable-libmount: remove dependency on host-util-linux libmount.
# --disable-physics: remove Bullet dependency.
# --enable-image-loader-gif=no: disable Gif dependency.
# --enable-image-loader-tiff=no: disable Tiff dependency.
# --enable-lua-old: disable Elua and remove luajit dependency.
# --with-crypto=none: remove dependencies on openssl or gnutls.
# --with-x11=none: remove dependency on X.org.
#   Yes I really know what I am doing.
HOST_LIBEFL_CONF_OPTS += \
	--disable-audio \
	--disable-cxx-bindings \
	--disable-fontconfig \
	--disable-fribidi \
	--disable-gstreamer1 \
	--disable-libeeze \
	--disable-libmount \
	--disable-multisense \
	--disable-physics \
	--enable-image-loader-gif=no \
	--enable-image-loader-jpeg=yes \
	--enable-image-loader-png=yes \
	--enable-image-loader-tiff=no \
	--enable-lua-old \
	--with-crypto=none \
	--with-glib=yes \
	--with-opengl=none \
	--with-x11=none \
	--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba

$(eval $(host-autotools-package))
