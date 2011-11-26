# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Tool for setting the X11 root window background with support for transparency"
HOMEPAGE="http://www.eterm.org/"
SRC_URI="http://perlovka.net/pub/gentoo/distfiles/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sh sparc x86"

DEPEND="!x11-terms/eterm
	media-libs/imlib2
	x11-libs/libast"

src_compile(){
econf || die "conf failed"
emake || die "emake failed"
}

src_install(){
make DESTDIR=${D} install || die "install failed"
}
