# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="Klipper is a 3d-printer firmware"
HOMEPAGE="https://github.com/KevinOConnor/${PN}"
SRC_URI="https://github.com/KevinOConnor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/cffi
	dev-python/greenlet
	dev-python/pyserial"

DEPEND="${RDEPEND}"

pkg_setup() {
	KLIPPER_HOME="/var/lib/klipper"

	ebegin "Creating klipper user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 "/bin/bash" "${KLIPPER_HOME}" ${PN}
	eend $?

}

src_compile() {
	:;
}

pkg_preinst() {
	if [[ -e ${ROOT%/}${KLIPPER_HOME}/printer.cfg ]]; then
		KLIPPER_CONFIG=1
	fi
}

src_install() {
	dodir /var/lib/${PN}
	insinto /var/lib/${PN}

	doins -r config docs klippy lib scripts src
	doins Makefile README.md

	if [[ ! -e ${ROOT%/}${KLIPPER_HOME}/printer.cfg ]]; then
		cp -a "${S}/config/example.cfg" "${D}/var/lib/${PN}/printer.cfg" || die
	fi

	fowners -R klipper:klipper /var/lib/${PN}

	newconfd "${FILESDIR}"/klipper.confd klipper
	newinitd "${FILESDIR}"/klipper.initd klipper
}

pkg_postinst() {
	if [[ -z $KLIPPER_CONFIG ]]; then
		einfo "Example configuration has been installed to /var/lib/${PN}/printer.cfg"
		einfo "Please review and change appropriately before using klipper"
		einfo "Documentation is available online at https://github.com/KevinOConnor/klipper/blob/master/docs/Overview.md"
	fi
}
