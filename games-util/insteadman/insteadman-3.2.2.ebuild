# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop go-module xdg

DESCRIPTION="Manager for INSTEAD games"
HOMEPAGE="https://jhekasoft.github.io/insteadman/"
SRC_URI="https://github.com/jhekasoft/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	http://perlovka.net/pub/gentoo/distfiles/insteadman-${PV}-vendor.tar.xz
	"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -o insteadman ./cli
	ego build -o insteadman-gtk ./gtk
}

src_install() {
	dobin insteadman
	dobin insteadman-gtk

	newicon "resources/images/logo.svg" insteadman.svg

	default
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
