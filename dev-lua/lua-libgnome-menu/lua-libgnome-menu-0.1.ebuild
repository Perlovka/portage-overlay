# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( luajit )

inherit lua-single

DESCRIPTION="Lua FFI bindings for libgnome-menu"
HOMEPAGE="https://github.com/Perlovka/lua-libgnome-menu"
SRC_URI="https://github.com/Perlovka/lua-libgnome-menu/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
RDEPEND="${LUA_DEPS}
	gnome-base/gnome-menus"

DEPEND="${RDEPEND}"

src_install() {
	insinto "$(lua_get_lmod_dir)"
	doins ./libgnome-menu.lua
}
