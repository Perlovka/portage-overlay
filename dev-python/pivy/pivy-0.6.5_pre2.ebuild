# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PV="0.6.5a2"

DESCRIPTION="Coin3d binding for Python"
HOMEPAGE="https://bitbucket.org/Coin3D/pivy"
SRC_URI="https://github.com/FreeCAD/pivy/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/SoQt"

DEPEND="${RDEPEND}
	dev-lang/swig
"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default

	# Fix SoQt lookup
	sed -i 's/pivy_cmake_setup NONE/pivy_cmake_setup/' CMakeLists.txt || die
}
