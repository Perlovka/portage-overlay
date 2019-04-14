# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An FFI implementation of the Linux kernel ABI for LuaJIT"
HOMEPAGE="http://www.myriabit.com/ljsyscall/"
SRC_URI="https://github.com/justincormack/ljsyscall/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/lua:="

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins syscall.lua
	doins -r syscall
}
