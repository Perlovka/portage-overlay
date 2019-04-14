# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="This library transforms any Lua value into a human-readable representation"
HOMEPAGE="https://github.com/kikito/inspect.lua"
SRC_URI="https://github.com/kikito/inspect.lua/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/lua:="

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}.lua-${PV}"

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins inspect.lua
}
