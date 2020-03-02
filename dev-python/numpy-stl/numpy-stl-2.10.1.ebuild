# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="This library facilitates communication between Cura and its backend"
HOMEPAGE="https://github.com/WoLpH/numpy-stl"
SRC_URI="https://github.com/WoLpH/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="test? ( dev-python/pytest-runner[${PYTHON_USEDEP}]	)"
RDEPEND="${PYTHON_DEPS}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/python-utils[${PYTHON_USEDEP}]
"

python_prepare_all() {
	! use test && export PYTEST_RUNNER='false'
	distutils-r1_python_prepare_all
}
