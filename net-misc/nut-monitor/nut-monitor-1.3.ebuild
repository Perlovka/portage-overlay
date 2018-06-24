# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="A graphical application to monitor and manage UPSes connected to a NUT server"
HOMEPAGE="https://www.lestat.st/en/informatique/projets/nut-monitor"
SRC_URI="http://www.lestat.st/_media/informatique/projets/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_fr"

RDEPEND="dev-python/pygtk
	dev-python/pynut"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-paths.patch
	epatch "${FILESDIR}"/${P}-paths2.patch
	python_fix_shebang .
	default
}

src_install() {
	dobin NUT-Monitor
	dosym NUT-Monitor /usr/bin/${PN}

	insinto /usr/share/nut-monitor
	doins gui-${PV}.glade

	dodir /usr/share/nut-monitor/pixmaps
	insinto /usr/share/nut-monitor/pixmaps
	doins pixmaps/*

	sed -i -e 's/nut-monitor.png/nut-monitor/' -e 's/Application;//' nut-monitor.desktop

	doicon ${PN}.png
	domenu ${PN}.desktop

	dodoc README

	if use l10n_fr; then
		insinto /usr/share/locale/fr/LC_MESSAGES/
		doins locale/fr/LC_MESSAGES/NUT-Monitor.mo
	fi
}
