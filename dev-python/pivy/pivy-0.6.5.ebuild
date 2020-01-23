# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Coin3d binding for Python"
HOMEPAGE="https://github.com/coin3d/pivy"
SRC_URI="https://github.com/coin3d/pivy/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+quarter soqt"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( quarter soqt )
"

RDEPEND="
	quarter? ( media-libs/quarter )
	soqt? ( media-libs/SoQt )
"

DEPEND="${RDEPEND}
	dev-lang/swig
"

src_prepare() {
	default

	# Fix Coin lookup
	sed -i 's/pivy_cmake_setup NONE/pivy_cmake_setup/' CMakeLists.txt || die
}
