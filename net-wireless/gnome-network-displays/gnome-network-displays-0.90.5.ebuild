# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Miracast implementation for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-network-displays"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+faac -firewalld openh264 +x264"
RESTRICT="test"

REQUIRED_USE="
	|| ( openh264 x264 )
	|| ( faac )
"

DEPEND="
	media-libs/x264
	media-libs/fdk-aac
	net-misc/networkmanager
"
RDEPEND="${DEPEND}
	media-libs/gst-rtsp-server
	media-plugins/gst-plugins-ximagesrc
	net-wireless/wpa_supplicant[p2p]
	faac? ( media-plugins/gst-plugins-faac )
	openh264? ( media-plugins/gst-plugins-openh264 )
	x264? ( media-plugins/gst-plugins-x264 )
"

S="${WORKDIR}/${PN}-v${PV}"

src_configure() {
	local emesonargs=(
		-Dfirewalld_zone=$(usex firewalld true false)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
