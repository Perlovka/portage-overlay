# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="This library facilitates communication between Cura and its backend"
HOMEPAGE="https://github.com/WoLpH/python-utils"
SRC_URI="https://github.com/WoLpH/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="${PYTHON_DEPS}
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest-runner[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	if ! use test; then
		sed -i -e '/pytest/d' setup.py || die
	fi
	distutils-r1_python_prepare_all
}
