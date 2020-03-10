# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

MY_PN=Candle

DESCRIPTION="GRBL controller application with G-Code visualizer written in Qt"
HOMEPAGE="https://github.com/Denvi/Candle"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Denvi/Candle.git"
	KEYWORDS="~amd64"
else
	SRC_URI="https://github.com/Denvi/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/FreeCAD-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

BDEPEND=""
RDEPEND=""
DEPEND="${RDEPEND}"

#DOCS=( README.md )
PATCHES=( "${FILESDIR}/${P}-fix_config_location.patch" )
S="${WORKDIR}/${P}/src"

src_prepare() {
#	sed -i "s/set(CURA_VERSION \"master\"/set(CURA_VERSION \"${PV}\"/" CMakeLists.txt || die
	cmake_src_prepare
}

#src_configure() {
#	local mycmakeargs=(
#		-DPYTHON_SITE_PACKAGES_DIR="$(python_get_sitedir)"
#	)
#	cmake_src_configure
#}

src_install() {
	newbin ../../${P}_build/Candle candle

	insinto /usr/share/applications/
	doins "${FILESDIR}/candle.desktop"

	newicon images/icon.svg candle.svg
}
