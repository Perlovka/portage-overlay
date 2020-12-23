# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="A tool for monitoring, capturing and storing TCP connections flows"
HOMEPAGE="https://github.com/simsong/tcpflow"
SRC_URI="
    https://api.github.com/repos/simsong/tcpflow/tarball/a5965b11a332fe908ab1ed136b14803920e8ecdb -> ${P}.tar.gz
"

LICENSE="GPL-3"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
SLOT="0"
IUSE="cairo test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite
	dev-libs/boost:=
	dev-libs/openssl:=
	net-libs/http-parser:=
	net-libs/libpcap
	sys-libs/libcap-ng
	sys-libs/zlib:=
	cairo? (
		x11-libs/cairo
	)
"
DEPEND="
	${RDEPEND}
	test? ( sys-apps/coreutils )
"
S=${WORKDIR}/simsong-${PN}-a5965b1
PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-gentoo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cxxflags -fpermissive
	econf $(usex cairo --enable-cairo=true --enable-cairo=false)
}
