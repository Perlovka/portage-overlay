# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit cmake-utils desktop python-single-r1 xdg

DESCRIPTION="Qt based Computer Aided Design application"
HOMEPAGE="https://www.freecadweb.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FreeCAD/FreeCAD.git"
else
	SRC_URI="https://github.com/FreeCAD/FreeCAD/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/FreeCAD-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc openscad"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-cpp/eigen:3
	dev-libs/boost:=[python,threads,${PYTHON_USEDEP}]
	dev-libs/libspnav[X]
	dev-libs/xerces-c[icu]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pivy[${PYTHON_USEDEP}]
	dev-python/pyside:2[svg,widgets,gui,${PYTHON_USEDEP}]
	dev-python/shiboken:2[${PYTHON_USEDEP}]
	dev-qt/assistant:5
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/coin
	media-libs/freetype
	sci-libs/med
	sci-libs/opencascade:7.3.0=[vtk(+)]
	sci-libs/orocos_kdl
	sys-libs/zlib
	virtual/glu
	openscad? ( media-gfx/openscad )
"

#	dev-libs/zipios

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
"

BDEPEND="
	dev-python/pyside-tools:2[${PYTHON_USEDEP}]
	dev-lang/swig
"

DOCS=( README.md ChangeLog.txt )

CMAKE_BUILD_TYPE=Release

pkg_setup() {
	python-single-r1_pkg_setup
	[[ -z ${CASROOT} ]] && die "empty \$CASROOT, run eselect opencascade set or define otherwise"
}

src_prepare() {
	cmake-utils_src_prepare

	# Fix external zipios lookup
#	sed -i -e 's#zipios++/zipios-config.h#zipios/zipios-config.hpp#' \
#		-e 's#${ZIPIOS}#${ZIPIOS_LIBRARY}#' src/Base/CMakeLists.txt || die

	# Fix OPENMPI includes
#	sed -i 's/OPENMPI_INCLUDE_DIRS/OPENMPI_INCLUDEDIR/' CMakeLists.txt || die
	rm -f "${S}/cMake/FindCoin3D.cmake" || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_QT5=ON
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_DATADIR="/usr/share/${PN}"
		-DCMAKE_INSTALL_DOCDIR="/usr/share/doc/${PF}"
		-DCMAKE_INSTALL_INCLUDEDIR="/usr/include/${PN}"
		-DCMAKE_INSTALL_PREFIX="/usr/$(get_libdir)/${PN}"
#		-DCMAKE_INSTALL_PREFIX="/opt/${PN}"
		-DFREECAD_USE_EXTERNAL_KDL="ON"
#		-DFREECAD_USE_EXTERNAL_ZIPIOS="ON"
		-DOCC_INCLUDE_DIR="${CASROOT}/include/opencascade"
		-DOCC_LIBRARY_DIR="${CASROOT}/lib"
	)

	cmake-utils_src_configure
	einfo "${P} will be built against opencascade version ${CASROOT}"
}

src_install() {
	cmake-utils_src_install

	dosym "${EPREFIX}"/usr/lib64/${PN}/bin/FreeCAD /usr/bin/freecad
	dosym "${EPREFIX}"/usr/lib64/${PN}/bin/FreeCADCmd /usr/bin/freecadcmd

	make_desktop_entry freecad "FreeCAD" "" "" "MimeType=application/x-extension-fcstd;"

	# install mimetype for FreeCAD files
	insinto /usr/share/mime/packages
	newins "${FILESDIR}"/${PN}.sharedmimeinfo "${PN}.xml"

	pushd "${ED%/}"/usr/share/${PN} || die
	local size
	for size in 16 32 48 64; do
		newicon -s ${size} freecad-icon-${size}.png freecad.png
	done
	doicon -s scalable freecad.svg
	newicon -s 64 -c mimetypes freecad-doc.png application-x-extension-fcstd.png
	popd || die

	python_optimize "${ED%/}"/usr/share/${PN}/Mod/ "${ED}"/usr/$(get_libdir)/${PN}{/Ext,/Mod}/
}
