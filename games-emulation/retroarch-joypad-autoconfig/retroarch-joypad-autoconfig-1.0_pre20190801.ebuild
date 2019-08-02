# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="9e77673e118d52a998072e3dcab1499e9b106df2"

DESCRIPTION="RetroArch joypad autoconfig files"
HOMEPAGE="https://github.com/libretro/retroarch-joypad-autoconfig"
SRC_URI="https://github.com/libretro/${PN}/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="CC-BY-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${LIBRETRO_COMMIT_SHA}"

src_compile(){
	:
}

src_install() {
	emake DESTDIR="${D}" INSTALLDIR="/usr/share/retroarch/autoconfig" install
}
