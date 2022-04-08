# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Wifi-Display/Miracast Implementation"
HOMEPAGE="https://github.com/albfan/miraclecast"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Perlovka/miraclecast.git"
	EGIT_BRANCH="optional-systemd"
	KEYWORDS="~amd64"
else
	SRC_URI="https://github.com/albfan/miraclecast/archive/v${PV}.tar.gz -> ${P}.tgz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="systemd test"

COMMONDEPEND="
	dev-libs/glib
	systemd? ( sys-apps/systemd )
	!systemd? (
		sys-auth/elogind
		virtual/udev
	)
"
RDEPEND="${COMMONDEPEND}
	media-libs/gstreamer
	media-plugins/gst-plugins-libav
"
DEPEND="${COMMONDEPEND}
	test? ( dev-libs/check )
"

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEMD=$(usex systemd)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /etc/dbus-1/system.d
	doins res/org.freedesktop.miracle.conf
}
