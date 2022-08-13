# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="New LuaJIT FFI based API for lua-nginx-module"
HOMEPAGE="https://github.com/openresty/lua-resty-core"
SRC_URI="https://github.com/openresty/lua-resty-core/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lua/resty-lrucache"
DEPEND="${RDEPEND}"

DOCS=(README.markdown)

S="${WORKDIR}/lua-${P}"

src_install() {
	emake DESTDIR="${D}" LUA_LIB_DIR="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)" install
}
