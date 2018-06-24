# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="An abstraction class written in Python to access NUT (Network UPS Tools) server"
HOMEPAGE="https://www.lestat.st/en/informatique/projets/pynut"
SRC_URI="http://www.lestat.st/_media/informatique/projets/pynut/python-${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/python-${P}"

src_install() {
	installation() {
		insinto $(python_get_sitedir)
		doins PyNUT.py
	}
	python_foreach_impl installation

	dodoc README
}
