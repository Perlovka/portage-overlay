# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake-utils

DESCRIPTION="The glue between Coin3D and Qt"
HOMEPAGE="https://bitbucket.org/Coin3D/soqt"
SRC_URI="https://bitbucket.org/Coin3D/soqt/downloads/soqt-1.6.0-src.zip"
RESTRICT="primaryuri"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+coin-iv-extensions doc spacenav"

RDEPEND=">=media-libs/coin-4
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	spacenav? ( dev-libs/libspnav:= )
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"

DOCS=( AUTHORS ChangeLog FAQ HACKING NEWS README )

S="${WORKDIR}/soqt"

src_configure() {
	local mycmakeargs=(
		-DCOIN_IV_EXTENSIONS=$(usex coin-iv-extensions ON OFF)
		-DSOQT_BUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DHAVE_SPACENAV_SUPPORT=$(usex spacenav ON OFF)
	)

	cmake-utils_src_configure
}
