# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3})

inherit eutils cmake lua-single

DESCRIPTION="Simple Text Adventure Interpreter"
HOMEPAGE="https://instead-hub.github.io/"
SRC_URI="https://github.com/instead-hub/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit"

RDEPEND="${LUA_DEPS}
	media-libs/sdl2-image
	media-libs/libsdl2[X]
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	luajit? ( dev-lang/luajit:= )"

DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i 's#\(include/luajit-2.0\)#\1 include/luajit-2.1#' "cmake/FindLuaJIT.cmake" || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-D WITH_SDL2=1
		-D WITH_LUAJIT=$(usex luajit)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
