# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="The glue between Coin3D and Qt"
HOMEPAGE="https://bitbucket.org/Coin3D/soqt"
SRC_URI="https://github.com/coin3d/soqt/archive/SoQt-${PV}.tar.gz
		https://github.com/coin3d/cpack.d/archive/master.zip -> coin3d-cpack.d-master.zip
		https://github.com/coin3d/soanydata/archive/master.zip -> coin3d-soanydata-master.zip
		https://github.com/coin3d/sogui/archive/master.zip -> coin3d-sogui-master.zip"

RESTRICT="primaryuri"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+coin-iv-extensions doc spacenav"

RDEPEND=">=media-libs/coin-4
	<media-libs/coin-4.0.0a_pre
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	spacenav? ( dev-libs/libspnav:= )
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"

DOCS=( AUTHORS ChangeLog FAQ HACKING NEWS README )

S="${WORKDIR}/${PN,,}-${P}"

src_prepare() {
	default
	mv "${WORKDIR}/cpack.d-master" "${S}/cpack.d" || die
	mv "${WORKDIR}/soanydata-master" "${S}/data" || die
	mv "${WORKDIR}/sogui-master" "${S}/src/Inventor/Qt/common" || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCOIN_IV_EXTENSIONS=$(usex coin-iv-extensions ON OFF)
		-DSOQT_BUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DHAVE_SPACENAV_SUPPORT=$(usex spacenav ON OFF)
	)

	cmake_src_configure
}
