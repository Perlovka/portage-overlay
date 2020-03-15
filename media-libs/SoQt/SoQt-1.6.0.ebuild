# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

SOANYDATA_COMMIT_SHA="3ff6e9203fbb0cc08a2bdf209212b7ef4d78a1f2"
SOGUI_COMMIT_SHA="4b0019d1ecc2b9ad3e77333b9f243b57a15ebc4e"

DESCRIPTION="The glue between Coin3D and Qt"
HOMEPAGE="https://bitbucket.org/Coin3D/soqt"
SRC_URI="https://github.com/coin3d/soqt/archive/SoQt-${PV}.tar.gz
		https://github.com/coin3d/soanydata/archive/${SOANYDATA_COMMIT_SHA}.tar.gz -> coin3d-soanydata-${SOANYDATA_COMMIT_SHA}.tar.gz
		https://github.com/coin3d/sogui/archive/${SOGUI_COMMIT_SHA}.zip -> coin3d-sogui-${SOGUI_COMMIT_SHA}.zip"

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
	mv "${WORKDIR}/soanydata-${SOANYDATA_COMMIT_SHA}" "${S}/data" || die
	mv "${WORKDIR}/sogui-${SOGUI_COMMIT_SHA}" "${S}/src/Inventor/Qt/common" || die
	sed -i '/add_subdirectory(cpack.d)/d' CMakeLists.txt || die

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
