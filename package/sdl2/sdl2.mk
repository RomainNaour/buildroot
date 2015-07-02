################################################################################
#
# sdl2
#
################################################################################

SDL2_VERSION = 2.0.3
SDL2_SOURCE = SDL2-$(SDL2_VERSION).tar.gz
SDL2_SITE = http://www.libsdl.org/release
SDL2_LICENSE = zlib
SDL2_LICENSE_FILES = COPYING.txt
SDL2_INSTALL_STAGING = YES

SDL2_CONF_OPTS += \
	--disable-rpath \
	--disable-arts \
	--disable-esd \
	--disable-pulseaudio \
	--disable-video-opengl \
	--disable-video-opengles

# We must enable static build to get compilation successful.
SDL2_CONF_OPTS += --enable-static

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
SDL2__DEPENDENCIES += udev
SDL2__CONF_OPTS += --enable-libudev
else
SDL2_CONF_OPTS += --disable-libudev
endif

ifeq ($(BR2_PACKAGE_SDL2_DIRECTFB),y)
SDL2_DEPENDENCIES += directfb
SDL2_CONF_OPTS += --enable-video-directfb=yes
SDL2_CONF_ENV = ac_cv_path_DIRECTFBCONFIG=$(STAGING_DIR)/usr/bin/directfb-config
else
SDL2_CONF_OPTS += --enable-video-directfb=no
endif

ifeq ($(BR2_PACKAGE_SDL2_X11),y)
SDL2_CONF_OPTS += --enable-video-x11=yes --with-x
SDL2_DEPENDENCIES += \
	xlib_libX11 xlib_libXext \
	$(if $(BR2_PACKAGE_XLIB_LIBXRENDER),xlib_libXrender) \
	$(if $(BR2_PACKAGE_XLIB_LIBXRANDR),xlib_libXrandr) \
	$(if $(BR2_PACKAGE_XLIB_LIBXCURSOR,xlib_libXcursor) \
	$(if $(BR2_PACKAGE_XLIB_LIBXINERAMA,xlib_libXinerama) \
	$(if $(BR2_PACKAGE_XPROTO_INPUTPROTO,xproto_inputproto) \
	$(if $(BR2_PACKAGE_XPROTO_SCRNSAVERPROTO,xproto_scrnsaverproto)
else
SDL2_CONF_OPTS += --enable-video-x11=no --without-x
endif

ifeq ($(BR2_PACKAGE_TSLIB),y)
SDL2_DEPENDENCIES += tslib
SDL2_CONF_OPTS += --enable-input-tslib
else
SDL2_CONF_OPTS += --disable-input-tslib
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
SDL2_DEPENDENCIES += alsa-lib
SDL2_CONF_OPTS += --enable-alsa
else
SDL2_CONF_OPTS += --disable-alsa
endif

$(eval $(autotools-package))
