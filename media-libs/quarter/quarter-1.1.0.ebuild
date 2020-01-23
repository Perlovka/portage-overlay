# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Coin GUI binding for Qt"
HOMEPAGE="https://github.com/coin3d/quarter"
SRC_URI="https://github.com/coin3d/quarter/archive/Quarter-${PV}.tar.gz
		https://github.com/coin3d/cpack.d/archive/master.zip -> coin3d-cpack.d-master.zip"
RESTRICT="primaryuri"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="designer doc examples"

BDEPEND="doc? ( app-doc/doxygen )"

RDEPEND="dev-libs/libspnav[X]
	dev-qt/qtopengl:5
	>=media-libs/coin-4
	<media-libs/coin-4.0.0a_pre
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-Quarter-${PV}"

src_prepare() {
	default

	sed -i '/# Fail early/a list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/SIMCMakeMacros")' CMakeLists.txt || die
	mv "${WORKDIR}/cpack.d-master" "${S}/cpack.d" || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DQUARTER_BUILD_PLUGIN=$(usex designer ON OFF)
		-DQUARTER_BUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DQUARTER_BUILD_EXAMPLES=$(usex examples ON OFF)
	)

	cmake_src_configure
}
