# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Intel Open Image Denoise library"
HOMEPAGE="http://www.openimagedenoise.org/"
SRC_URI="https://github.com/OpenImageDenoise/${PN}/releases/download/v${PV}/oidn-${PV}.src.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-cpp/tbb
	dev-lang/ispc
"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE="Release"
	)
	cmake_src_configure
}
