# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="Simple Text Adventure Interpreter"
HOMEPAGE="https://instead-hub.github.io/"
SRC_URI="https://github.com/instead-hub/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/lua:=
	dev-lang/luajit
	media-libs/sdl2-image
	media-libs/libsdl2[X]
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf"

src_configure() {
	local mycmakeargs=(
		-D WITH_SDL2=1
		-D WITH_LUAJIT=1
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
