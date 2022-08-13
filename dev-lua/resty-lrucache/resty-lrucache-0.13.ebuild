# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple LRU cache for OpenResty and the ngx_lua module based on the LuaJIT FFI"
HOMEPAGE="https://github.com/openresty/lua-resty-lrucache"
SRC_URI="https://github.com/openresty/lua-resty-lrucache/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

DOCS=(README.markdown)

S="${WORKDIR}/lua-${P}"

src_install() {
	emake DESTDIR="${D}" LUA_LIB_DIR="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)" install
}
