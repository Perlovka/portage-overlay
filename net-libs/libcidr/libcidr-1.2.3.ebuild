# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A library to automate various manipulations and comparisons of network blocks"
HOMEPAGE="http://www.over-yonder.net/~fullermd/projects/libcidr"
SRC_URI="http://www.over-yonder.net/~fullermd/projects/libcidr/libcidr-1.2.3.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( README RELNOTES )

src_install() {
	make PREFIX="/usr" DESTDIR="${D}" CIDR_LIBDIR="/usr/$(get_libdir)" CIDR_MANDIR="/usr/share/man" \
		$(usex !doc NO_DOCS=1 '') $(usex !examples NO_EXAMPLES=1 '') install || die
	einstalldocs
}
