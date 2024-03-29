# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Klipper is a 3d-printer firmware"
HOMEPAGE="https://github.com/klipper3d/${PN}"
SRC_URI="https://github.com/klipper3d/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND="
	dev-python/cffi
	dev-python/greenlet
	dev-python/pyserial
"

DEPEND="
	${RDEPEND}
	acct-group/klipper
	acct-user/klipper
"

pkg_setup() {
	KLIPPER_HOME="/var/lib/${PN}"
}

src_compile() {
	:;
}

src_install() {
	insinto ${KLIPPER_HOME}
	doins -r config klippy

	insinto ${KLIPPER_HOME}/firmware
	doins -r lib scripts src Makefile

	insinto /etc/${PN}
	newins "${S}/config/example.cfg" "klipper.conf"

	fowners -R ${PN}:${PN} ${KLIPPER_HOME}

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}

pkg_postinst() {
	if ! has_version app-misc/klipper; then
		einfo "Example configuration has been installed to /etc/${PN}/${PN}.conf"
		einfo "Please review and change appropriately before using klipper"
		einfo "Documentation is available online at https://github.com/KevinOConnor/klipper/blob/master/docs/Overview.md"
	fi

	[[ ! -x /usr/bin/avr-gcc ]] && ewarn "Missing avr-gcc; you need to crossdev -s4 avr"
}
