# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit cmake llvm python-r1

QT_PV="$(ver_cut 1-2):5"

DESCRIPTION="Tool for creating Python bindings for C++ libraries"
HOMEPAGE="https://wiki.qt.io/PySide2"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://code.qt.io/cgit/pyside/pyside-setup.git"
	EGIT_BRANCH="5.14"
	S="${WORKDIR}/${P}/sources/shiboken2"
else
	SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/pyside-setup-opensource-src-${PV}.tar.xz"
	S="${WORKDIR}/pyside-setup-opensource-src-${PV}/sources/shiboken2"
fi

# The "sources/shiboken2/libshiboken" directory is triple-licensed under the GPL
# v2, v3+, and LGPL v3. All remaining files are licensed under the GPL v3 with
# version 1.0 of a Qt-specific exception enabling shiboken2 output to be
# arbitrarily relicensed. (TODO)
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 ) GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="docstrings numpy test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="sys-devel/clang:=
	test? ( >=dev-qt/qttest-${QT_PV} )
"
RDEPEND="${PYTHON_DEPS}
	>=dev-qt/qtcore-${QT_PV}
	docstrings? (
		dev-libs/libxml2
		dev-libs/libxslt
		>=dev-qt/qtxml-${QT_PV}
		>=dev-qt/qtxmlpatterns-${QT_PV}
	)
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
"

DEPEND="${RDEPEND}"

DOCS=( AUTHORS )

# Ensure the path returned by get_llvm_prefix() contains clang as well.
llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

src_prepare() {
	#FIXME: File an upstream issue requesting a sane way to disable NumPy support.
	if ! use numpy; then
		sed -i -e '/print(os\.path\.realpath(numpy))/d' libshiboken/CMakeLists.txt || die
	fi

	# Fix clang include path
	sed -i 's#clangPathLibDir = findClangLibDir()#clangPathLibDir = QLatin1String("/usr/lib")#' ApiExtractor/clangparser/compilersupport.cpp || die

	cmake_src_prepare
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DBUILD_TESTS=$(usex test)
			-DDISABLE_DOCSTRINGS=$(usex !docstrings)
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DUSE_PYTHON_VERSION="${EPYTHON#python}"
#			-DPYTHON_SITE_PACKAGES="$(python_get_sitedir)"
		)
		cmake_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake_build
}

src_test() {
	python_foreach_impl cmake_src_test
}

src_install() {
	installation() {
		cmake_src_install
		python_optimize
		cp "${ED}"/usr/bin/${PN}2{,-${EPYTHON}} || die
		cp "${ED}"/usr/$(get_libdir)/pkgconfig/${PN}2{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation

	#     https://bugreports.qt.io/browse/PYSIDE-1053
	#     https://github.com/leycec/raiagent/issues/74
	sed -i \
		-e 's~shiboken2-python[[:digit:]]\+\.[[:digit:]]\+~shiboken2${PYTHON_CONFIG_SUFFIX}~g' \
		-e 's~/bin/shiboken2~/bin/shiboken2${PYTHON_CONFIG_SUFFIX}~g' \
		"${ED}/usr/$(get_libdir)"/cmake/Shiboken2-${PV}/Shiboken2Targets-gentoo.cmake || die

	# Remove the broken "shiboken_tool.py" script. By inspection, this script
	# reduces to a noop. Moreover, this script raises the following exception:
	#     FileNotFoundError: [Errno 2] No such file or directory: '/usr/bin/../shiboken_tool.py': '/usr/bin/../shiboken_tool.py'
	rm "${ED}"/usr/bin/shiboken_tool.py || die
}
