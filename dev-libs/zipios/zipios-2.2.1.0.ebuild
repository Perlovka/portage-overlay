# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="C++ library for reading and writing Zip files using streams"
HOMEPAGE="https://github.com/Zipios/Zipios"
SRC_URI="https://github.com/Zipios/Zipios/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/Zipios-${PV}"

src_prepare() {
	cmake-utils_src_prepare

	# Install cmake file to proper location
	sed -i 's#share/cmake/ZipIos#share/cmake/Modules RENAME FindZIPIOS.cmake#' cmake/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DBUILD_ZIPIOS_TESTS=$(usex test ON OFF)
	)

	cmake-utils_src_configure
}
