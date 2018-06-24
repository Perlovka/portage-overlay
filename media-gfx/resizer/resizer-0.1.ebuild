# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Tool for resizing images"
HOMEPAGE="http://perlovka.net/"
SRC_URI="http://perlovka.net/pub/gentoo/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/imlib2"

src_install(){
	emake DESTDIR="${D}" install || die "Install failed"
}
