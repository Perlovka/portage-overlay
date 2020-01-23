# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake python-single-r1

DESCRIPTION="AST-based Python refactoring library"
HOMEPAGE="https://github.com/pybind/pybind11"
SRC_URI="https://github.com/pybind/pybind11/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	test? (
		dev-cpp/catch:0
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
	)
"

DEPEND="${PYTHON_DEP}"
DOCS=( README.md CONTRIBUTING.md ISSUE_TEMPLATE.md )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	mycmakeargs=(
		-DPYBIND11_INSTALL=ON
		-DPYBIND11_TEST=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	cmake_src_test
	pushd "${BUILD_DIR}" || die
	eninja check
	popd || die
}
