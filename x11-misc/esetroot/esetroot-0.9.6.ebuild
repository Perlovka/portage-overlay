# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Tool for setting the X11 root window background with support for transparency"
HOMEPAGE="http://www.eterm.org/"
SRC_URI="http://perlovka.net/pub/gentoo/distfiles/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="!x11-terms/eterm
	media-libs/imlib2[X]
	x11-libs/libast"

src_prepare() {
	eautoreconf
	eautomake
}

src_configure() {
	econf
}

src_compile() {
	emake
}
