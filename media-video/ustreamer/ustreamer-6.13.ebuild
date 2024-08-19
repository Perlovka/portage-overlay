# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="uStreamer - Lightweight and fast MJPEG-HTTP streamer"
HOMEPAGE="https://github.com/pikvm/ustreamer"
SRC_URI="https://github.com/pikvm/ustreamer/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""

DEPEND="
	dev-libs/libevent
	media-libs/libjpeg-turbo
	dev-libs/libbsd
"
RDEPEND="${DEPEND}"
BDEPEND=""

RESTRICT="primaryuri"

src_install() {
	dobin ustreamer
	dobin ustreamer-dump
	doman man/ustreamer.1
	doman man/ustreamer-dump.1

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}
