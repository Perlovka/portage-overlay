# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_IN_SOURCE_BUILD="1"
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit cmake python-r1 virtualx

DESCRIPTION="PySide development tools (lupdate, rcc, uic)"
HOMEPAGE="https://wiki.qt.io/PySide2"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://code.qt.io/pyside/pyside-tools.git"
	EGIT_BRANCH="5.14"
else
	SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/pyside-setup-opensource-src-${PV}.tar.xz"
	S="${WORKDIR}/pyside-setup-opensource-src-${PV}/sources/pyside2-tools"
fi

# Although "LICENSE-uic" suggests the "pyside2uic" directory to be dual-licensed
# under the BSD 3-clause and GPL v2 licenses, this appears to be an oversight;
# all files in this (and every) directory are licensed only under the GPL v2.
LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test tools"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# The "pyside2uic" package imports both the "PySide2.QtGui" and
# "PySide2.QtWidgets" C extensions and hence requires "widgets".
RDEPEND="${PYTHON_DEPS}
	>=dev-python/pyside-${PV}[widgets,${PYTHON_USEDEP}]
	tools? ( !dev-qt/qtchooser )
"

DEPEND="${RDEPEND}
	test? ( virtual/pkgconfig )
"

src_prepare() {
	cmake_src_prepare

	python_copy_sources

	preparation() {
		pushd "${BUILD_DIR}" >/dev/null || die

		if python_is_python3; then
			# Remove Python 2-specific paths.
			rm -rf pyside2uic/port_v2 || die

			# Generate proper Python 3 test interfaces with the "-py3" option.
			sed -i -e 's:${PYSIDERCC_EXECUTABLE}:"${PYSIDERCC_EXECUTABLE} -py3":' \
				tests/rcc/CMakeLists.txt || die
		else
			# Remove Python 3-specific paths.
			rm -rf pyside2uic/port_v3 || die
		fi

		# Force testing against the current Python version.
		sed -i -e "/pkg-config/ s:shiboken2:&-${EPYTHON}:" \
			tests/rcc/run_test.sh || die

		popd >/dev/null || die
	}
	python_foreach_impl preparation
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DBUILD_TESTS=$(usex test)
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
		)

		CMAKE_USE_DIR="${BUILD_DIR}" cmake_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	compilation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake_build
	}
	python_foreach_impl compilation
}

src_test() {
	testing() {
		local -x PYTHONDONTWRITEBYTECODE
		CMAKE_USE_DIR="${BUILD_DIR}" virtx cmake_src_test
	}
	python_foreach_impl testing
}

src_install() {
	installation() {
		CMAKE_USE_DIR="${BUILD_DIR}" cmake_src_install
	}
	python_foreach_impl installation

	if ! use tools; then
		rm "${ED}"/usr/bin/{rcc,uic,designer} || die
	fi

	rm "${ED}"/usr/bin/pyside_tool.py || die
}
