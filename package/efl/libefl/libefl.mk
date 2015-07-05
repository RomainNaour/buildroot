################################################################################
#
# libefl
#
################################################################################

# hardcode the version here since the bump to 1.15 is not complete in Buildroot
LIBEFL_VERSION = 1.15.2
LIBEFL_SOURCE = efl-$(LIBEFL_VERSION).tar.xz
LIBEFL_SITE = http://download.enlightenment.org/rel/libs/efl
LIBEFL_LICENSE = BSD-2c, LGPLv2.1+, GPLv2+
LIBEFL_LICENSE_FILES = COPYING

LIBEFL_INSTALL_STAGING = YES

LIBEFL_DEPENDENCIES = host-pkgconf host-libefl dbus freetype jpeg libcurl lua \
	udev zlib

# regenerate the configure script:
# https://phab.enlightenment.org/T2718
# configure.ac patched by 0002-ecore_x-Remove-XPrint-usage.patch
LIBEFL_AUTORECONF = YES
LIBEFL_GETTEXTIZE = YES

# Configure options:
# --disable-cxx-bindings: disable C++11 bindings.
# --enable-lua-old: disable Elua and remove luajit dependency.
# --with-x11=none: remove dependency on X.org.
LIBEFL_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eolian-gen=$(HOST_DIR)/usr/bin/eolian_gen \
	--disable-cxx-bindings \
	--enable-lua-old \
	--enable-lua-old

# Disable untested configuration warning.
ifeq ($(BR2_PACKAGE_LIBEFL_RECOMMENDED_CONFIG),)
LIBEFL_CONF_OPTS += --enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba
endif

# Libmount is used heavily inside Eeze for support of removable devices etc.
# and disabling this will hurt support for Enlightenment and its filemanager.
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),y)
LIBEFL_DEPENDENCIES += util-linux
LIBEFL_CONF_OPTS += --enable-libmount
else
LIBEFL_CONF_OPTS += --disable-libmount
endif

# libblkid is part of required tools, see EFL's README.
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBBLKID),y)
LIBEFL_DEPENDENCIES += util-linux
endif

# If fontconfig is disabled, this is going to make general font
# searching not work, and only some very direct 'load /path/file.ttf'
# will work alongside some old-school ttf file path searching. This
# is very likely not what you want, so highly reconsider turning
# fontconfig off. Having it off will lead to visual problems like
# missing text in many UI areas etc.
ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
LIBEFL_CONF_OPTS += --enable-fontconfig
LIBEFL_DEPENDENCIES += fontconfig
else
LIBEFL_CONF_OPTS += --disable-fontconfig
endif

# Fribidi is used for handling right-to-left text (like Arabic,
# Hebrew, Farsi, Persian etc.) and is very likely not a feature
# you want to disable unless you know for absolute certain you
# will never encounter and have to display such scripts. Also
# note that we don't test with fribidi disabled so you may also
# trigger code paths with bugs that are never normally used.
ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
LIBEFL_CONF_OPTS += --enable-fribidi
LIBEFL_DEPENDENCIES += libfribidi
else
LIBEFL_CONF_OPTS += --disable-fribidi
endif

# If Gstreamer 1.x support is disabled, it will heavily limit your media
# support options and render some functionality as useless, leading to
# visible application bugs.
ifeq ($(BR2_PACKAGE_GSTREAMER1)$(BR2_PACKAGE_GST1_PLUGINS_BASE),yy)
LIBEFL_CONF_OPTS += --enable-gstreamer1
LIBEFL_DEPENDENCIES += gstreamer1 gst1-plugins-base
else
LIBEFL_CONF_OPTS += --disable-gstreamer1
endif

# You have chosen to disable physics support. This disables lots of
# core functionality and is effectively never tested. You are going
# to find features that suddenly don't work and as a result cause
# a series of breakages. This is simply not tested so you are on
# your own in terms of ensuring everything works if you do this
ifeq ($(BR2_PACKAGE_BULLET),y)
LIBEFL_CONF_OPTS += --enable-physics
LIBEFL_DEPENDENCIES += bullet
else
LIBEFL_CONF_OPTS += --disable-physics
endif

# You disabled audio support in Ecore. This is not tested and may
# Create bugs for you due to it creating untested code paths.
# Reconsider disabling audio.
ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
LIBEFL_CONF_OPTS += --enable-audio
LIBEFL_DEPENDENCIES += libsndfile
else
LIBEFL_CONF_OPTS += --disable-audio
endif

# The only audio output method supported by Ecore right now is via
# Pulseaudio. You have disabled that and likely have broken a whole
# bunch of things in the process. Reconsider your configure options.
# NOTE: multisense support is automatically enabled with pulseaudio.
ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
LIBEFL_CONF_OPTS += --enable-pulseaudio
LIBEFL_DEPENDENCIES += pulseaudio
else
LIBEFL_CONF_OPTS += --disable-pulseaudio
endif

# There is no alsa support yet in Ecore_Audio.
# configure will disable alsa support even if alsa-lib is selected.

ifeq ($(BR2_PACKAGE_HARFBUZZ),y)
LIBEFL_DEPENDENCIES += harfbuzz
LIBEFL_CONF_OPTS += --enable-harfbuzz=yes
else
LIBEFL_CONF_OPTS += --enable-harfbuzz=no
endif

ifeq ($(BR2_PACKAGE_TSLIB),y)
LIBEFL_DEPENDENCIES += tslib
LIBEFL_CONF_OPTS += --enable-tslib
else
LIBEFL_CONF_OPTS += --disable-tslib
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
LIBEFL_DEPENDENCIES += libglib2
# we can also say "always"
LIBEFL_CONF_OPTS += --with-glib=yes
else
LIBEFL_CONF_OPTS += --with-glib=no
endif

# Prefer openssl (the default) over gnutls.
ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBEFL_DEPENDENCIES += openssl
LIBEFL_CONF_OPTS += --with-crypto=openssl
else
ifeq ($(BR2_PACKAGE_GNUTLS)$(BR2_PACKAGE_LIBGCRYPT),yy)
LIBEFL_DEPENDENCIES += gnutls libgcrypt
LIBEFL_CONF_OPTS += --with-crypto=gnutls \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
LIBEFL_CONF_OPTS += --with-crypto=none
endif
endif # BR2_PACKAGE_OPENSSL

ifeq ($(BR2_PACKAGE_WAYLAND),y)
LIBEFL_DEPENDENCIES += wayland libxkbcommon
LIBEFL_CONF_OPTS += --enable-wayland=yes
else
LIBEFL_CONF_OPTS += --enable-wayland=no
endif

ifeq ($(BR2_PACKAGE_LIBEFL_FB),y)
LIBEFL_CONF_OPTS += --enable-fb=yes
else
LIBEFL_CONF_OPTS += --enable-fb=no
endif

ifeq ($(BR2_PACKAGE_LIBEFL_X),y)
LIBEFL_CONF_OPTS += --with-x=$(STAGING_DIR) \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib

LIBEFL_DEPENDENCIES += \
	xlib_libX11 \
	xlib_libXext
else
LIBEFL_CONF_OPTS += --with-x=no \
	--with-x11=none
endif

ifeq ($(BR2_PACKAGE_LIBEFL_X_XLIB_GLX_FULL),y)
LIBEFL_CONF_OPTS += --with-opengl=full
LIBEFL_DEPENDENCIES += libgl
endif

ifeq ($(BR2_PACKAGE_LIBEFL_X_XLIB_GLX_ES),y)
LIBEFL_CONF_OPTS += --with-opengl=es
LIBEFL_DEPENDENCIES += libgles
endif

ifeq ($(BR2_PACKAGE_LIBEFL_X_XLIB_GLX_NONE),y)
LIBEFL_CONF_OPTS += --with-opengl=none
endif

ifeq ($(BR2_PACKAGE_LIBEFL_X_XLIB),y)
LIBEFL_DEPENDENCIES += \
	xlib_libX11 \
	xlib_libXcomposite \
	xlib_libXcursor \
	xlib_libXdamage \
	xlib_libXext \
	xlib_libXinerama \
	xlib_libXrandr \
	xlib_libXrender \
	xlib_libXScrnSaver \
	xlib_libXtst
LIBEFL_CONF_OPTS += --with-x11=xlib
endif

# xcb-util-image to provide xcb-image.pc
# xcb-util-renderutil to provide xcb-renderutil.pc
# xcb-util-wm to provide xcb-icccm.pc
# xcb-util-keysyms to provide xcb-keysyms.pc
ifeq ($(BR2_PACKAGE_LIBEFL_X_XCB),y)
LIBEFL_DEPENDENCIES += libxcb \
	xcb-util-image \
	xcb-util-keysyms \
	xcb-util-renderutil \
	xcb-util-wm
# You have chosen to use XCB instead of Xlib. It is a myth that XCB
# is amazingly faster than Xlib (when used sensibly). It can be
# faster in a few corner cases on startup of an app, but it comes
# with many downsides. One of those is more complex code inside
# ecore_x, which is far less tested in XCB mode than Xlib. Also
# the big catch is that OpenGL support basically requires Xlib anyway
# so if you want OpenGL in X11, you need Xlib regardless and so you
# gain nothing really in terms of speed and no savings in memory
# because Xlib is still linked, loaded and used, BUT instead you
# have OpenGL drivers working with an hybrid XCB/Xlib (mostly XCB)
# toolkit and this is basically never tested by anyone working on
# the OpenGL drivers, so you will have bugs. Do not enable XCB
# and use OpenGL. XCB is only useful if you wish to shave a few Kb
# off the memory footprint of a whole system and live with less
# tested code, and possibly unimplemented features in ecore_x. To
# remove the XCB setup, remove the --with-x11=xcb option to
# configure.
LIBEFL_CONF_OPTS += --with-x11=xcb
endif

# image loader: handle only loaders that requires dependencies.
# All other loaders are builded by default statically.
ifeq ($(BR2_PACKAGE_LIBEFL_PNG),y)
LIBEFL_CONF_OPTS += --enable-image-loader-png=yes
LIBEFL_DEPENDENCIES += libpng
else
LIBEFL_CONF_OPTS += --enable-image-loader-png=no
endif

ifeq ($(BR2_PACKAGE_LIBEFL_JPEG),y)
LIBEFL_CONF_OPTS += --enable-image-loader-jpeg=yes
else
LIBEFL_CONF_OPTS += --enable-image-loader-jpeg=no
endif

ifeq ($(BR2_PACKAGE_LIBEFL_GIF),y)
LIBEFL_CONF_OPTS += --enable-image-loader-gif=yes
LIBEFL_DEPENDENCIES += giflib
else
LIBEFL_CONF_OPTS += --enable-image-loader-gif=no
endif

ifeq ($(BR2_PACKAGE_LIBEFL_TIFF),y)
LIBEFL_CONF_OPTS += --enable-image-loader-tiff=yes
LIBEFL_DEPENDENCIES += tiff
else
LIBEFL_CONF_OPTS += --enable-image-loader-tiff=no
endif

ifeq ($(BR2_PACKAGE_LIBEFL_JP2K),y)
LIBEFL_CONF_OPTS += --enable-image-loader-jp2k=yes
LIBEFL_DEPENDENCIES += openjpeg
else
LIBEFL_CONF_OPTS += --enable-image-loader-jp2k=no
endif

ifeq ($(BR2_PACKAGE_LIBEFL_WEBP),y)
LIBEFL_CONF_OPTS += --enable-image-loader-webp=yes
LIBEFL_DEPENDENCIES += webp
else
LIBEFL_CONF_OPTS += --enable-image-loader-webp=no
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
