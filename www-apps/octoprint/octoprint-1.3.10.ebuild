# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

MY_PN="OctoPrint"

DESCRIPTION="Web interface for 3D printers"
HOMEPAGE="https://octoprint.org/"
SRC_URI="https://github.com/foosel/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

pkg_setup() {
	OCTO_HOME="/var/lib/${PN}"
	OCTO_ENV="${OCTO_HOME}/octo-env"

	ebegin "Creating ${PN} user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 "/bin/bash" "${OCTO_HOME}" ${PN}
	eend $?
}

src_compile() {
	:;
}

src_install() {

	dodir /var/lib/${PN}
	insinto /var/lib/${PN}

	doins *.md

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	fowners -R ${PN}:${PN} /var/lib/${PN}
}

pkg_preinst() {

	# Create virtualenv if it doesn't already exist
	if [[ ! -d ${ROOT%/}${OCTO_ENV} ]]; then
		ebegin "Creating python virtual environment..."
		virtualenv -p python2 ${OCTO_ENV} || die
	fi

	cd "${S}"

	# Force easy_install to unpack eggs
	echo -e "\n[easy_install]\nzip_ok = False" >> setup.cfg || die

	${OCTO_ENV}/bin/python setup.py install || die

	chown -R ${PN}:${PN} /var/lib/${PN} || die
}
