################################################################################
#
# efl
#
################################################################################

EFL_VERSION = 1.14.2
EFL_SOURCE = efl-$(EFL_VERSION).tar.xz
EFL_SITE = http://download.enlightenment.org/rel/libs/efl/
EFL_LICENSE = BSD-2c, LGPLv2.1+, GPLv2+
EFL_LICENSE_FILES = COPYING

EFL_INSTALL_STAGING = YES

EFL_DEPENDENCIES = host-pkgconf host-efl dbus freetype jpeg libcurl lua udev \
	zlib

# Makefiles bundled with efl archive have some issue when linking
# with libecore.so when cross-compiling.
EFL_AUTORECONF = YES
EFL_GETTEXTIZE = YES

# Configure options:
# --disable-cxx-bindings: disable C++11 bindings.
# --enable-lua-old: disable Elua and remove luajit dependency.
# --with-x11=none: remove dependency on X.org.
EFL_CONF_OPTS = \
	--with-edje-cc=$(HOST_DIR)/usr/bin/edje_cc \
	--with-eolian-gen=$(HOST_DIR)/usr/bin/eolian_gen \
	--disable-cxx-bindings \
	--enable-lua-old

# Disable untested configuration warning.
ifeq ($(BR2_PACKAGE_EFL_RECOMMENDED_CONFIG),)
EFL_CONF_OPTS += --enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba
endif

# Libmount is used heavily inside Eeze for support of removable devices etc.
# and disabling this will hurt support for Enlightenment and its filemanager.
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),y)
EFL_DEPENDENCIES += util-linux
EFL_CONF_OPTS += --enable-libmount
else
EFL_CONF_OPTS += --disable-libmount
endif

# libblkid is part of required tools, see EFL's README.
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBBLKID),y)
EFL_DEPENDENCIES += util-linux
endif

# If fontconfig is disabled, this is going to make general font
# searching not work, and only some very direct 'load /path/file.ttf'
# will work alongside some old-school ttf file path searching. This
# is very likely not what you want, so highly reconsider turning
# fontconfig off. Having it off will lead to visual problems like
# missing text in many UI areas etc.
ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
EFL_CONF_OPTS += --enable-fontconfig
EFL_DEPENDENCIES += fontconfig
else
EFL_CONF_OPTS += --disable-fontconfig
endif

# Fribidi is used for handling right-to-left text (like Arabic,
# Hebrew, Farsi, Persian etc.) and is very likely not a feature
# you want to disable unless you know for absolute certain you
# will never encounter and have to display such scripts. Also
# note that we don't test with fribidi disabled so you may also
# trigger code paths with bugs that are never normally used.
ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
EFL_CONF_OPTS += --enable-fribidi
EFL_DEPENDENCIES += libfribidi
else
EFL_CONF_OPTS += --disable-fribidi
endif

# If Gstreamer 1.x support is disabled, it will heavily limit your media
# support options and render some functionality as useless, leading to
# visible application bugs.
ifeq ($(BR2_PACKAGE_GSTREAMER1)$(BR2_PACKAGE_GST1_PLUGINS_BASE),yy)
EFL_CONF_OPTS += --enable-gstreamer1
EFL_DEPENDENCIES += gstreamer1 gst1-plugins-base
else
EFL_CONF_OPTS += --disable-gstreamer1
endif

# You have chosen to disable physics support. This disables lots of
# core functionality and is effectively never tested. You are going
# to find features that suddenly don't work and as a result cause
# a series of breakages. This is simply not tested so you are on
# your own in terms of ensuring everything works if you do this
ifeq ($(BR2_PACKAGE_BULLET),y)
EFL_CONF_OPTS += --enable-physics
EFL_DEPENDENCIES += bullet
else
EFL_CONF_OPTS += --disable-physics
endif

# You disabled audio support in Ecore. This is not tested and may
# Create bugs for you due to it creating untested code paths.
# Reconsider disabling audio.
ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
EFL_CONF_OPTS += --enable-audio
EFL_DEPENDENCIES += libsndfile
else
EFL_CONF_OPTS += --disable-audio
endif

# The only audio output method supported by Ecore right now is via
# Pulseaudio. You have disabled that and likely have broken a whole
# bunch of things in the process. Reconsider your configure options.
ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
EFL_CONF_OPTS += --enable-pulseaudio
EFL_DEPENDENCIES += pulseaudio
else
EFL_CONF_OPTS += --disable-pulseaudio
endif

# The configure script check for GNU gettext in libc or libintl (uClibc)
ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
EFL_DEPENDENCIES += gettext
endif

# There is no alsa support yet in Ecore_Audio.
# configure will disable alsa support even if alsa-lib is selected.

ifeq ($(BR2_PACKAGE_HARFBUZZ),y)
EFL_DEPENDENCIES += harfbuzz
EFL_CONF_OPTS += --enable-harfbuzz=yes
else
EFL_CONF_OPTS += --enable-harfbuzz=no
endif

ifeq ($(BR2_PACKAGE_TSLIB),y)
EFL_DEPENDENCIES += tslib
EFL_CONF_OPTS += --enable-tslib
else
EFL_CONF_OPTS += --disable-tslib
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
EFL_DEPENDENCIES += libglib2
# we can also say "always"
EFL_CONF_OPTS += --with-glib=yes
else
EFL_CONF_OPTS += --with-glib=no
endif

# Prefer openssl (the default) over gnutls.
ifeq ($(BR2_PACKAGE_OPENSSL),y)
EFL_DEPENDENCIES += openssl
EFL_CONF_OPTS += --with-crypto=openssl
else
ifeq ($(BR2_PACKAGE_GNUTLS)$(BR2_PACKAGE_LIBGCRYPT),yy)
EFL_DEPENDENCIES += gnutls libgcrypt
EFL_CONF_OPTS += --with-crypto=gnutls \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
EFL_CONF_OPTS += --with-crypto=none
endif
endif # BR2_PACKAGE_OPENSSL

ifeq ($(BR2_PACKAGE_WAYLAND),y)
EFL_DEPENDENCIES += wayland libxkbcommon
EFL_CONF_OPTS += --enable-wayland=yes
else
EFL_CONF_OPTS += --enable-wayland=no
endif

ifeq ($(BR2_PACKAGE_EFL_FB),y)
EFL_CONF_OPTS += --enable-fb=yes
else
EFL_CONF_OPTS += --enable-fb=no
endif

ifeq ($(BR2_PACKAGE_EFL_SDL2),y)
EFL_CONF_OPTS += --enable-sdl=yes
EFL_DEPENDENCIES += sdl2
else
EFL_CONF_OPTS += --enable-sdl=no
endif

ifeq ($(BR2_PACKAGE_EFL_X_XLIB_GLX_FULL)$(BR2_PACKAGE_EFL_SDL2),yy)
EFL_DEPENDENCIES += sdl_gfx libglu
endif

ifeq ($(BR2_PACKAGE_EFL_X),y)
EFL_CONF_OPTS += --with-x=$(STAGING_DIR) \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib

EFL_DEPENDENCIES += \
	xlib_libX11 \
	xlib_libXext
else
EFL_CONF_OPTS += --with-x=no \
	--with-x11=none
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXPRESENT),y)
EFL_CONF_OPTS += --enable-xpresent
EFL_DEPENDENCIES += xlib_libXpresent
endif

ifeq ($(BR2_PACKAGE_EFL_X_XLIB_GLX_FULL),y)
EFL_CONF_OPTS += --with-opengl=full
EFL_DEPENDENCIES += libgl
endif

ifeq ($(BR2_PACKAGE_EFL_X_XLIB_GLX_ES),y)
EFL_CONF_OPTS += --with-opengl=es
EFL_DEPENDENCIES += libgles
endif

ifeq ($(BR2_PACKAGE_EFL_X_XLIB_GLX_NONE),y)
EFL_CONF_OPTS += --with-opengl=none
endif

ifeq ($(BR2_PACKAGE_EFL_X_XLIB),y)
EFL_DEPENDENCIES += \
	xlib_libX11 \
	xlib_libXcomposite \
	xlib_libXcursor \
	xlib_libXdamage \
	xlib_libXext \
	xlib_libXinerama \
	xlib_libXp \
	xlib_libXrandr \
	xlib_libXrender \
	xlib_libXScrnSaver \
	xlib_libXtst
EFL_CONF_OPTS += --with-x11=xlib
endif

# xcb-util-image to provide xcb-image.pc
# xcb-util-renderutil to provide xcb-renderutil.pc
# xcb-util-wm to provide xcb-icccm.pc
# xcb-util-keysyms to provide xcb-keysyms.pc
ifeq ($(BR2_PACKAGE_EFL_X_XCB),y)
EFL_DEPENDENCIES += libxcb \
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
EFL_CONF_OPTS += --with-x11=xcb
endif

# image loader: handle only loaders that requires dependencies.
# All other loaders are builded by default statically.
ifeq ($(BR2_PACKAGE_EFL_PNG),y)
EFL_CONF_OPTS += --enable-image-loader-png=yes
EFL_DEPENDENCIES += libpng
else
EFL_CONF_OPTS += --enable-image-loader-png=no
endif

ifeq ($(BR2_PACKAGE_EFL_JPEG),y)
EFL_CONF_OPTS += --enable-image-loader-jpeg=yes
else
EFL_CONF_OPTS += --enable-image-loader-jpeg=no
endif

ifeq ($(BR2_PACKAGE_EFL_GIF),y)
EFL_CONF_OPTS += --enable-image-loader-gif=yes
EFL_DEPENDENCIES += giflib
else
EFL_CONF_OPTS += --enable-image-loader-gif=no
endif

ifeq ($(BR2_PACKAGE_EFL_TIFF),y)
EFL_CONF_OPTS += --enable-image-loader-tiff=yes
EFL_DEPENDENCIES += tiff
else
EFL_CONF_OPTS += --enable-image-loader-tiff=no
endif

ifeq ($(BR2_PACKAGE_EFL_JP2K),y)
EFL_CONF_OPTS += --enable-image-loader-jp2k=yes
EFL_DEPENDENCIES += openjpeg
else
EFL_CONF_OPTS += --enable-image-loader-jp2k=no
endif

ifeq ($(BR2_PACKAGE_EFL_WEBP),y)
EFL_CONF_OPTS += --enable-image-loader-webp=yes
EFL_DEPENDENCIES += webp
else
EFL_CONF_OPTS += --enable-image-loader-webp=no
endif

$(eval $(autotools-package))

################################################################################
#
# host-efl
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
HOST_EFL_DEPENDENCIES = \
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
HOST_EFL_CONF_OPTS += \
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
