# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="2a8bef8b99b8456e91dd1343fe912578f0acae74"

DESCRIPTION="RetroArch assets"
HOMEPAGE="https://github.com/libretro/retroarch-assets"
SRC_URI="https://github.com/libretro/${PN}/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="CC-BY-4.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${LIBRETRO_COMMIT_SHA}"

src_install() {
	emake DESTDIR="${D}" INSTALLDIR="/usr/share/retroarch/assets" install
}
