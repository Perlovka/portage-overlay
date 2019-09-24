# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python2_7 python3_{5,6,7} pypy pypy3)

inherit distutils-r1

DESCRIPTION="Python flexible slugify function"
HOMEPAGE="https://github.com/dimka665/awesome-slugify"
LICENSE="GPL-3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

BDEPEND=""
RDEPEND="
	dev-python/regex
	>=dev-python/unidecode-0.04.14
	<dev-python/unidecode-0.05
"
