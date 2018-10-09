# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Lua bindings for the Linux inotify library"
HOMEPAGE="https://github.com/GUI/lua-libcidr-ffi"
SRC_URI="https://github.com/GUI/lua-libcidr-ffi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/lua:=
	net-libs/libcidr"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/lua-${P}"

src_compile() {
	:;
}

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins lib/*
}
