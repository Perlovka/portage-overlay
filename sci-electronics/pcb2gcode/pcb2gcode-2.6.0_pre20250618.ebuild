# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools desktop qmake-utils xdg-utils

DESCRIPTION="A command-line software for the isolation, routing and drilling of PCBs."
HOMEPAGE="https://github.com/pcb2gcode/pcb2gcode"

SRC_URI="https://github.com/${PN}/${PN}/archive/07c6df4cad2712e3cac7143f04e7a97a71f970b2.tar.gz -> ${P}.tar.gz
	gui? (
		https://github.com/${PN}/pcb2gcodeGUI/archive/ed8acfcf162bbe281affd3dbb0818ce39e604aae.tar.gz -> ${P}-gui.tar.gz
	)
"

S="${WORKDIR}/pcb2gcode-07c6df4cad2712e3cac7143f04e7a97a71f970b2"
GUI_DIR="pcb2gcodeGUI-ed8acfcf162bbe281affd3dbb0818ce39e604aae"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+geos gui"

DEPEND="
	geos? ( sci-libs/geos )
	dev-cpp/glibmm
	dev-cpp/gtkmm:3.0
	dev-libs/boost
	gnome-base/librsvg
	sci-electronics/gerbv
"

src_prepare() {
	default
	eautoreconf

	# pcb2gcode config looks for gtkmm-2.4.pc file, but current gtkmm puts gtkmm-3.x.pc
	# Providing gdkmm_CFLAGS and gdkmm_LIBS turns off lookup ans use provided values directly.
	gdkmm_pc="$(pkg-config --list-package-names | grep gtkmm)"
	export gdkmm_CFLAGS="$(pkg-config ${gdkmm_pc} --cflags)"
	export gdkmm_LIBS="$(pkg-config ${gdkmm_pc} --libs)"
}

src_configure() {
	default

	if use gui; then
		cd "../${GUI_DIR}/"
		eqmake5 PREFIX="${EPREFIX}"/usr
	fi
}

src_compile() {
	emake GIT_VERSION="${PV}" || die

	if use gui; then
		cd "../${GUI_DIR}/"
		emake
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	if use gui; then
		cd "../${GUI_DIR}/"
		dobin pcb2gcodeGUI

		make_desktop_entry "/usr/bin/pcb2gcodeGUI" "pcb2gcode" "pcb2gcode" "Electronics;Science"
		doicon "${FILESDIR}/${PN}.png"
	fi
}

pkg_postinst() {
	if use gui; then
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use gui; then
		xdg_icon_cache_update
	fi
}
