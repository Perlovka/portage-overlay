# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils python-r1 virtualx

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="https://wiki.qt.io/PySide2"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://code.qt.io/pyside/pyside-setup.git"
	EGIT_BRANCH="5.11"
	S="${WORKDIR}/${P}/sources/pyside2"
else
	SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/pyside-setup-everywhere-src-${PV}.tar.xz"
	S="${WORKDIR}/pyside-setup-everywhere-src-${PV}/sources/pyside2"
fi

# See "sources/pyside2/PySide2/licensecomment.txt" for licensing details.
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 )"
SLOT="2"
KEYWORDS="~amd64 ~x86"

# TODO: speech
IUSE="charts concurrent datavis declarative designer gui help multimedia
	network opengl printsupport script scripttools sql svg test testlib
	webchannel webengine webkit websockets widgets x11extras xmlpatterns"

# The requirements below were extracted from the output of
# 'grep "set(.*_deps" "${S}"/PySide2/Qt*/CMakeLists.txt'
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	charts? ( widgets )
	datavis? ( gui )
	declarative? ( gui network )
	designer? ( widgets )
	help? ( widgets )
	multimedia? ( gui network )
	opengl? ( widgets )
	printsupport? ( widgets )
	scripttools? ( gui script widgets )
	sql? ( widgets )
	svg? ( widgets )
	testlib? ( widgets )
	webengine? ( gui network webchannel widgets )
	webkit? ( gui network printsupport widgets )
	websockets? ( network )
	widgets? ( gui )
	x11extras? ( gui )"

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/shiboken-${PV}:${SLOT}[${PYTHON_USEDEP}]
	dev-qt/qtcore
	dev-qt/qtxml
	charts? ( dev-qt/qtcharts:5 )
	concurrent? ( dev-qt/qtconcurrent:5 )
	datavis? ( dev-qt/qtdatavis3d:5 )
	declarative? ( dev-qt/qtdeclarative:5[widgets?] )
	designer? ( dev-qt/designer:5 )
	gui? ( dev-qt/qtgui:5 )
	help? ( dev-qt/qthelp:5 )
	multimedia? ( dev-qt/qtmultimedia:5[widgets?] )
	network? ( dev-qt/qtnetwork:5 )
	opengl? ( dev-qt/qtopengl:5 )
	printsupport? ( dev-qt/qtprintsupport:5 )
	script? ( dev-qt/qtscript:5 )
	sql? ( dev-qt/qtsql:5 )
	svg? ( dev-qt/qtsvg:5 )
	testlib? ( dev-qt/qttest:5 )
	webchannel? ( dev-qt/qtwebchannel:5 )
	webengine? ( dev-qt/qtwebengine:5[widgets] )
	webkit? ( dev-qt/qtwebkit:5[printsupport] )
	websockets? ( dev-qt/qtwebsockets:5 )
	widgets? ( dev-qt/qtwidgets:5 )
	x11extras? ( dev-qt/qtx11extras:5 )
	xmlpatterns? ( dev-qt/qtxmlpatterns:5 )
"

RDEPEND="${DEPEND}"

src_prepare() {
	if use prefix; then
		cp "${FILESDIR}"/rpath.cmake . || die
		sed -i -e '1iinclude(rpath.cmake)' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	# See COLLECT_MODULE_IF_FOUND macros in CMakeLists.txt
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Charts=$(usex !charts)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Concurrent=$(usex !concurrent)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5DataVisualization=$(usex !datavis)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Designer=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Gui=$(usex !gui)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Help=$(usex !help)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Multimedia=$(usex !multimedia)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5MultimediaWidgets=$(usex !multimedia yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Network=$(usex !network)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5OpenGL=$(usex !opengl)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5PrintSupport=$(usex !printsupport)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Qml=$(usex !declarative)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Quick=$(usex !declarative)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5QuickWidgets=$(usex !declarative yes $(usex !widgets))
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Script=$(usex !script)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5ScriptTools=$(usex !scripttools)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Sql=$(usex !sql)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Svg=$(usex !svg)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=$(usex !testlib)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5UiTools=$(usex !designer)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebChannel=$(usex !webchannel)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineWidgets=$(usex !webengine)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebKit=$(usex !webkit)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebKitWidgets=$(usex !webkit)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebSockets=$(usex !websockets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Widgets=$(usex !widgets)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5X11Extras=$(usex !x11extras)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5XmlPatterns=$(usex !xmlpatterns)
	)

	configuration() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_EXECUTABLE="${PYTHON}"
		)
		cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	local -x PYTHONDONTWRITEBYTECODE
	python_foreach_impl virtx cmake-utils_src_test
}

src_install() {
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}2{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}
