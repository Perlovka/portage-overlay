# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake desktop qmake-utils xdg

GUI_COMMIT="cffcf1a2ac2360ca8b0cf2cc0298d237cd5dde5d"

DESCRIPTION="A command-line software for the isolation, routing and drilling of PCBs."
HOMEPAGE="https://github.com/pcb2gcode/pcb2gcode"

SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	gui? (
		https://github.com/${PN}/pcb2gcodeGUI/archive/${GUI_COMMIT}.tar.gz -> ${P}-gui.tar.gz
	)
"

GUI_DIR="pcb2gcodeGUI-${GUI_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+geos gui"

RESTRICT="primaryuri"

DEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-libs/boost
	gnome-base/librsvg
	sci-electronics/gerbv
	geos? ( sci-libs/geos )
	gui? ( dev-qt/qtsvg:6 )
"

src_configure() {
	cmake_src_configure

	if use gui; then
		cd "../${GUI_DIR}" || die
		eqmake6 PREFIX="${EPREFIX}"/usr
	fi
}

src_compile() {
	cmake_src_compile

	if use gui; then
		cd "../${GUI_DIR}" || die
		emake
	fi
}

src_install() {
	cmake_src_install

	if use gui; then
		cd "../${GUI_DIR}" || die
		dobin pcb2gcodeGUI

		make_desktop_entry "/usr/bin/pcb2gcodeGUI" "pcb2gcode" "pcb2gcode" "Electronics;Science"
		doicon "${FILESDIR}/${PN}.png"
	fi
}

pkg_postinst() {
	if use gui; then
		xdg_pkg_postinst
	fi
}

pkg_postrm() {
	if use gui; then
		xdg_pkg_postrm
	fi
}
