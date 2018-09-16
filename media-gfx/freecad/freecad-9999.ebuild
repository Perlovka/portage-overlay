# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit cmake-utils xdg-utils gnome2-utils python-single-r1

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
KEYWORDS="~amd64 ~x86"
IUSE="doc openscad"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	dev-cpp/eigen:3
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	dev-libs/libspnav
	dev-libs/xerces-c[icu]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pyside:2[svg,widgets,gui,${PYTHON_USEDEP}]
	dev-python/shiboken:2[${PYTHON_USEDEP}]
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	dev-qt/qtwidgets:5
	dev-qt/qtprintsupport:5
	dev-qt/qtopengl:5
	dev-qt/qtsvg:5
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtwebkit:5
	media-libs/coin
	media-libs/freetype
	sci-libs/libmed
	sci-libs/opencascade:7.3.0=[vtk(+)]
	sci-libs/orocos_kdl
	sys-libs/zlib
	virtual/glu
"

RDEPEND="${COMMON_DEPEND}
	openscad? ( media-gfx/openscad )
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pivy[${PYTHON_USEDEP}]
	dev-qt/assistant:5
"

DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen[dot] )
	dev-lang/swig:0
	dev-python/pyside-tools:2[${PYTHON_USEDEP}]
"

DOCS=( README.md ChangeLog.txt )

pkg_setup() {
	python-single-r1_pkg_setup

	[[ -z ${CASROOT} ]] && die "empty \$CASROOT, run eselect opencascade set or define otherwise"
}

src_prepare() {

	cmake-utils_src_prepare

	if [[ ${PV} != *9999 ]]; then
		eapply "${FILESDIR}/${P}-boost-python-fix.patch"
	fi

	# Fix OPENMPI includes
	sed -i 's/OPENMPI_INCLUDE_DIRS/OPENMPI_INCLUDEDIR/' CMakeLists.txt || die
	rm -f "${S}/cMake/FindCoin3D.cmake" || die

}

src_configure() {
	#-DOCC_* defined with cMake/FindOpenCasCade.cmake
	#-DCOIN3D_* defined with cMake/FindCoin3D.cmake
	#-DSOQT_ not used
	local mycmakeargs=(
		-DBUILD_QT5=ON
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_PREFIX="/opt/${PN}"
#        -DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/${PN}"
#        -DCMAKE_INSTALL_INCLUDEDIR="${EPREFIX}/usr/include/${PN}"
#        -DCMAKE_INSTALL_DATADIR="${EPREFIX}/usr/share/${PN}"
#        -DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DFREECAD_USE_EXTERNAL_KDL="ON"
		-DOCC_INCLUDE_DIR="${CASROOT}"/include/opencascade
		-DOCC_LIBRARY_DIR="${CASROOT}"/lib
	)

	# TODO: Remove embedded dependencies
	#
	#  - -DFREECAD_USE_EXTERNAL_ZIPIOS="ON" - this option needs zipios++
	#     but it's not yet in portage so the embedded zipios++ (under
	#     src/zipios++) will be used
	#
	#  - salomesmesh is in 3rdparty but upstream's find_package function
	#    is not complete yet to compile against external version
	#    (external salomesmesh is available in "science" overlay)

	cmake-utils_src_configure
	einfo "${P} will be built against opencascade version ${CASROOT}"
}

src_install() {
	cmake-utils_src_install

	dosym "${EPREFIX}"/opt/${PN}/bin/FreeCAD /usr/bin/FreeCAD
	dosym "${EPREFIX}"/opt/${PN}/bin/FreeCADCmd /usr/bin/FreeCADCmd

	make_desktop_entry FreeCAD "FreeCAD" "" "" "MimeType=application/x-extension-fcstd;"

	# install mimetype for FreeCAD files
	insinto /usr/share/mime/packages
	newins "${FILESDIR}"/${PN}.sharedmimeinfo "${PN}.xml"

	# install icons to correct place rather than /opt/freecad/data
	pushd "${ED%/}"/opt/${PN}/data || die
	local size
	for size in 16 32 48 64; do
		newicon -s ${size} freecad-icon-${size}.png freecad.png
	done
	doicon -s scalable freecad.svg
	newicon -s 64 -c mimetypes freecad-doc.png application-x-extension-fcstd.png
	popd || die

	python_optimize "${ED%/}"/opt/${PN}/{,data/}Mod/
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
