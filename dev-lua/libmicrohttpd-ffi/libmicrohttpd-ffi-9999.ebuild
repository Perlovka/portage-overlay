# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 toolchain-funcs

DESCRIPTION="FFI wrapper for libmicrohttpd"
HOMEPAGE="https://github.com/hwhw/ffi_libmicrohttpd"
EGIT_REPO_URI="https://github.com/hwhw/ffi_libmicrohttpd"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="virtual/pkgconfig"

RDEPEND="dev-lang/lua:=
	net-libs/libmicrohttpd"

DEPEND="${RDEPEND}"

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins ./libmicrohttpd.lua
}
