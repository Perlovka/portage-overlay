# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Universal frontend for libretro-based emulators"
HOMEPAGE="http://www.retroarch.com"

SRC_URI="https://github.com/libretro/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

S="${WORKDIR}/RetroArch-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm"

IUSE="+7zip alsa armvfp +cheevos dbus debug discord
	dispmanx egl ffmpeg gles2 gles3 jack kms libass libcaca
	libsixel libusb materialui mbedtls mpv neon +network openal +opengl
	osmesa oss overlay pulseaudio qt sdl sdl2 +truetype +threads +udev v4l2
	videocore vulkan wayland +X xinerama +xmb +xml xv zlib cpu_flags_x86_sse2"

REQUIRED_USE="
	alsa? ( threads )
	arm? ( gles2? ( egl ) )
	!arm? (
		egl? ( opengl )
		gles2? ( opengl )
		xmb? ( opengl )
	)
	dispmanx? ( videocore arm )
	gles3? ( gles2 )
	kms? ( egl )
	libass? ( ffmpeg )
	sdl2? ( !sdl )
	videocore? ( arm )
	vulkan? ( amd64 )
	wayland? ( egl )
	xinerama? ( X )
	xv? ( X )
"
RDEPEND="
	alsa? ( media-libs/alsa-lib:0= )
	arm? ( dispmanx? ( || ( media-libs/raspberrypi-userland:0 media-libs/raspberrypi-userland-bin:0 ) ) )
	dbus? ( sys-apps/dbus:0= )
	discord? ( net-im/discord-bin:0= )
	ffmpeg? ( media-video/ffmpeg:0= )
	jack? ( virtual/jack:= )
	libass? ( media-libs/libass:0= )
	libcaca? ( media-libs/libcaca:0= )
	libsixel? ( media-libs/libsixel:0= )
	libusb? ( virtual/libusb:1= )
	mbedtls? ( net-libs/mbedtls:0= )
	mpv? ( media-video/mpv:0= )
	openal? ( media-libs/openal:0= )
	opengl? ( media-libs/mesa:0=[gles2?] )
	osmesa? ( media-libs/mesa:0=[osmesa?] )
	pulseaudio? ( media-sound/pulseaudio:0= )
	qt? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qtopengl:5
			dev-qt/qtwidgets:5
	)
	sdl? ( media-libs/libsdl:0=[joystick] )
	sdl2? ( media-libs/libsdl2:0=[joystick] )
	truetype? ( media-libs/freetype:2= )
	udev? ( virtual/udev:0=
		X? ( x11-drivers/xf86-input-evdev:0= )
	)
	amd64? ( vulkan? ( media-libs/vulkan-loader:0= ) )
	v4l2? ( media-libs/libv4l:0= )
	wayland? ( media-libs/mesa:0=[wayland?] )
	X? (
		x11-base/xorg-server:0=
		x11-libs/libxkbcommon:0=
	)
	xinerama? ( x11-libs/libXinerama:0= )
	xml? ( dev-libs/libxml2:2= )
	xv? ( x11-libs/libXv:0= )
	zlib? ( sys-libs/zlib:0= )
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	export RETROARCH_LIB_DIR="/usr/$(get_libdir)/retroarch"

	sed -i retroarch.cfg \
		-e 's:# \(libretro_directory =\):\1 "~/.local/share/libretro/cores/":' \
		-e 's:# \(cheat_database_path =\):\1 "~/.local/share/libretro/database/cheats/":' \
		-e 's:# \(content_database_path =\):\1 "~/.local/share/libretro/database/content/":' \
		-e 's:# \(libretro_info_path =\):\1 "~/.local/share/libretro/info/":' \
		-e 's:# \(overlay_directory =\):\1 "~/.local/share/libretro/overlays/":' \
		-e 's:# \(video_shader_dir =\):\1 "~/.local/share/libretro/shaders/":' \
		-e 's:# \(video_filter_dir =\):\1 "'${RETROARCH_LIB_DIR}'/filters/video/":' \
		-e 's:# \(audio_filter_dir =\):\1 "'${RETROARCH_LIB_DIR}'/filters/audio/":' \
		-e 's:# \(rgui_config_directory =\):\1 "~/.config/retroarch/":' \
		-e 's:# \(system_directory =\):\1 "~/.local/share/retroarch/system/":' \
		-e 's:# \(assets_directory =\):\1 "~/.local/share/retroarch/assets/":' \
		-e 's:# \(joypad_autoconfig_dir =\):\1 "~/.local/share/retroarch/autoconfig/":' \
		-e 's:# \(savestate_directory =\):\1 "~/.local/share/retroarch/savestates/":' \
		-e 's:# \(savefile_directory =\):\1 "~/.local/share/retroarch/savefiles/":' \
		-e 's:# \(screenshot_directory =\):\1 "~/.local/share/retroarch/screenshots/":' \
		-e 's:# \(menu_show_core_updater =\):\1 "true":' \
		-e 's:# \(content_directory =\):\1 "~/":' \
		-e 's:# \(rgui_browser_directory =\):\1 "~/":' \
		|| die '"sed" failed.'

	default_src_prepare
}

src_configure() {
	filter-flags --infodir

	# Note that OpenVG support is hard-disabled. (See ${RDEPEND} above.)
	# mpv is also not enabled by default, it doesn't seem to work with stable mpv.
	./configure --prefix="${EPREFIX}"/usr \
		$(use_enable 7zip) \
		$(use_enable alsa) \
		$(use_enable cheevos) \
		$(use_enable cpu_flags_x86_sse2 sse) \
		$(use_enable dbus) \
		$(use_enable discord) \
		$(use_enable dispmanx) \
		$(use_enable egl) \
		$(use_enable ffmpeg) \
		$(use_enable gles2 opengles) \
		$(use_enable gles3 opengles3) \
		$(use_enable jack) \
		$(use_enable kms) \
		$(use_enable libass ssa) \
		$(use_enable libcaca caca) \
		$(use_enable libusb) \
		$(use_enable materialui) \
		$(use_enable mbedtls ssl) \
		$(use_enable network networking) \
		$(use_enable neon) \
		$(use_enable openal al) \
		$(use_enable opengl) \
		$(use_enable osmesa) \
		$(use_enable oss) \
		$(use_enable overlay) \
		$(use_enable pulseaudio pulse) \
		$(use_enable qt) \
		$(use_enable sdl) \
		$(use_enable sdl2) \
		$(use_enable truetype freetype) \
		$(use_enable udev) \
		$(use_enable v4l2) \
		$(use_enable videocore) \
		$(use_enable vulkan) \
		$(use_enable wayland) \
		$(use_enable X x11) \
		$(use_enable xinerama) \
		$(use_enable xmb) \
		$(use_enable xv xvideo) \
		$(use_enable zlib) \
		--disable-vg \
		--docdir=/usr/share/doc/${PF} \
		|| die "configure failed."
}

src_compile() {
	# Filtering all -O* flags in favor of upstream ones
	filter-flags -O*
	emake $(usex debug "DEBUG=1" "")
	emake $(usex debug "build=debug" "build=release") -C gfx/video_filters/
	emake $(usex debug "build=debug" "build=release") -C libretro-common/audio/dsp_filters/
}

src_install() {
	emake DESTDIR="${D}" install

	# Install audio filters.
	insinto ${RETROARCH_LIB_DIR}/filters/audio/
	doins "${S}"/libretro-common/audio/dsp_filters/*.dsp

	# Install video filters.
	insinto ${RETROARCH_LIB_DIR}/filters/video/
	doins "${S}"/gfx/video_filters/*.filt
}

pkg_preinst() {
	has_version "<=${CATEGORY}/${PN}-${PVR}" || first_install="1"
}

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		ewarn ""
		ewarn "You need to make sure that all directories exist or you must modify your retroarch.cfg accordingly."
		ewarn "To create the needed directories for your user run as \$USER (not as root!):"
		ewarn ""
		ewarn "\$ mkdir -p ~/.local/share/retroarch/{savestates,savefiles,screenshots,system,cores}"
		ewarn ""
	fi
}
