# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit check-reqs cmake desktop python-single-r1 xdg

DESCRIPTION="Qt based Computer Aided Design application"
HOMEPAGE="https://www.freecadweb.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FreeCAD/FreeCAD.git"
else
	SRC_URI="https://github.com/FreeCAD/FreeCAD/archive/${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/FreeCAD-${PV}"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc mpi netgen pcl"

FREECAD_EXPERIMENTAL_MODULES="assembly complete reverseengineering ship plot"

FREECAD_STABLE_MODULES="addonmgr arch drawing fem idf image inspection
	material mesh openscad part_design path points raytracing robot show
	spreadsheet surface techdraw tux"

FREECAD_DISABLED_MODULES="vr"

FREECAD_ALL_MODULES="${FREECAD_STABLE_MODULES} ${FREECAD_EXPERIMENTAL_MODULES} ${FREECAD_DISABLED_MODULES}"

for module in ${FREECAD_STABLE_MODULES}; do
	IUSE="${IUSE} +${module}"
done

for module in ${FREECAD_EXPERIMENTAL_MODULES}; do
	IUSE="${IUSE} -${module}"
done

unset module

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	arch? ( mesh )
	debug? ( mesh )
	drawing? ( spreadsheet )
	fem? ( mesh )
	inspection? ( mesh points )
	netgen? ( fem )
	openscad? ( mesh )
	path? ( robot )
	reverseengineering? ( mesh )
	ship? ( plot image )
	techdraw? ( spreadsheet drawing )
"
#	dev-libs/zipios

BDEPEND="
	dev-python/pyside-tools:2[${PYTHON_USEDEP}]
	dev-lang/swig
	doc? (
		app-arch/p7zip
		app-doc/doxygen[dot]
	)
"

RDEPEND="${PYTHON_DEPS}
	dev-cpp/eigen:3
	dev-libs/boost:=[mpi?,python,threads,${PYTHON_USEDEP}]
	dev-libs/libspnav[X]
	dev-libs/xerces-c[icu]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pivy[${PYTHON_USEDEP}]
	dev-python/pyside:2[svg,gui,x11extras,xmlpatterns,${PYTHON_USEDEP}]
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
	media-libs/coin[draggers(+),manipulators(+),nodekits(+),simage(+)]
	media-libs/freetype
	sci-libs/flann[mpi?,openmp]
	sci-libs/med[mpi(+)?,python,${PYTHON_USEDEP}]
	sci-libs/opencascade:7.3.0=[vtk(+)]
	sci-libs/orocos_kdl:=
	sys-libs/zlib
	virtual/glu
	virtual/libusb:1
	addonmgr? ( dev-python/git-python[${PYTHON_USEDEP}] )
	fem? ( sci-libs/vtk[boost,mpi?,python,qt5,rendering,${PYTHON_USEDEP}] )
	mesh? (
		dev-python/pybind11[${PYTHON_USEDEP}]
		sci-libs/hdf5:=[fortran,mpi?,zlib]
	)
	mpi? (
		virtual/mpi[cxx,fortran,threads]
	)
	netgen? ( >=sci-mathematics/netgen-6.2.1810[mpi?,python,opencascade,${PYTHON_USEDEP}] )
	pcl? ( sci-libs/pcl:=[opengl,openni2(+),qt5(+),vtk(+)] )
	openscad? ( media-gfx/openscad )
"

DEPEND="${RDEPEND}"

DOCS=( README.md ChangeLog.txt )

CMAKE_BUILD_TYPE=Release

CHECKREQS_DISK_BUILD="7G"

pkg_setup() {
	check-reqs_pkg_setup
	python-single-r1_pkg_setup
	[[ -z ${CASROOT} ]] && die "empty \$CASROOT, run eselect opencascade set or define otherwise"
}

src_prepare() {
	rm -f "${S}/cMake/FindCoin3D.cmake" || die
	cmake_src_prepare

	# Fix external zipios lookup
#	sed -i -e 's#zipios++/zipios-config.h#zipios/zipios-config.hpp#' \
#		-e 's#${ZIPIOS}#${ZIPIOS_LIBRARY}#' src/Base/CMakeLists.txt || die

	# Fix OPENMPI includes
#	sed -i 's/OPENMPI_INCLUDE_DIRS/OPENMPI_INCLUDEDIR/' CMakeLists.txt || die

}

src_configure() {
	local mycmakeargs=(
		-DBUILD_ADDONMGR=$(usex addonmgr)
		-DBUILD_ARCH=$(usex arch)
		-DBUILD_ASSEMBLY=$(usex assembly)
		-DBUILD_COMPLETE=$(usex complete)
		-DBUILD_DRAFT=ON # basic workspace, enable it by default
		-DBUILD_DRAWING=$(usex drawing)
		-DBUILD_FEM=$(usex fem)
		-DBUILD_FEM_NETGEN=$(usex netgen)
		-DBUILD_FLAT_MESH=$(usex mesh)
		-DBUILD_FREETYPE=ON # automagic dep
		-DBUILD_GUI=ON
		-DBUILD_IDF=$(usex idf)
		-DBUILD_IMAGE=$(usex image)
		-DBUILD_IMPORT=ON # import module for various file formats
		-DBUILD_INSPECTION=$(usex inspection)
		-DBUILD_JTREADER=OFF # code has been removed upstream, but option is still there
		-DBUILD_MATERIAL=$(usex material)
		-DBUILD_MESH=$(usex mesh)
		-DBUILD_MESH_PART=$(usex mesh)
		-DBUILD_OPENSCAD=$(usex openscad)
		-DBUILD_PART=ON # basic workspace, enable it by default
		-DBUILD_PART_DESIGN=$(usex part_design)
		-DBUILD_PATH=$(usex path)
		-DBUILD_PLOT=$(usex plot)
		-DBUILD_POINTS=$(usex points)
		-DBUILD_QT5=ON # OFF means to use Qt4
		-DBUILD_RAYTRACING=$(usex raytracing)
		-DBUILD_REVERSEENGINEERING=$(usex reverseengineering)
		-DBUILD_ROBOT=$(usex robot)
		-DBUILD_SHIP=$(usex ship)
		-DBUILD_SHOW=$(usex show)
		-DBUILD_SKETCHER=ON # needed by draft workspace
		-DBUILD_SMESH=$(usex mesh)
		-DBUILD_SPREADSHEET=$(usex spreadsheet)
		-DBUILD_START=ON # basic workspace, enable it by default
		-DBUILD_SURFACE=$(usex surface)
		-DBUILD_TECHDRAW=$(usex techdraw)
		-DBUILD_TEST=$(usex debug)
		-DBUILD_TUX=$(usex tux)
		-DBUILD_VR=OFF
		-DBUILD_WEB=ON # needed by start workspace
		-DCMAKE_INSTALL_DATADIR=/usr/share/${PN}/data
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_INSTALL_INCLUDEDIR=/usr/include/${PN}
		-DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/${PN}
		-DFREECAD_USE_EXTERNAL_SMESH=OFF
		-DFREECAD_USE_EXTERNAL_KDL=ON
		-DFREECAD_USE_EXTERNAL_ZIPIOS=OFF # doesn't work yet, also no package in gentoo tree
		-DFREECAD_USE_FREETYPE=ON
		-DFREECAD_USE_PCL=$(usex pcl)
		-DFREECAD_USE_PYBIND11=$(usex mesh)
		-DOCC_INCLUDE_DIR="${CASROOT}"/include/opencascade
		-DOCC_LIBRARY_DIR="${CASROOT}"/$(get_libdir)
		-DOCCT_CMAKE_FALLBACK=ON # don't use occt-config which isn't included in opencascade for Gentoo
		-DCOIN3D_INCLUDE_DIRS=$(pkg-config --variable includedir Coin)
	)

	cmake_src_configure
	einfo "${P} will be built against opencascade version ${CASROOT}"
}

src_install() {
	cmake_src_install

	dosym ../$(get_libdir)/${PN}/bin/FreeCAD /usr/bin/freecad
	dosym ../$(get_libdir)/${PN}/bin/FreeCADCmd /usr/bin/freecadcmd

	mv "${ED}"/usr/$(get_libdir)/freecad/share/* "${ED}"/usr/share || die "failed to move shared resources"

	python_optimize "${ED}"/usr/share/${PN}/data/Mod/ "${ED}"/usr/$(get_libdir)/${PN}{/Ext,/Mod}/
}
