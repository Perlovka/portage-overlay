# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python2_7 python3_{5,6,7} pypy pypy3)

inherit distutils-r1

DESCRIPTION="Package to infer binary file types"
HOMEPAGE="https://github.com/h2non/filetype.py"
LICENSE="GPL-3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

BDEPEND=""
RDEPEND=""

src_prepare() {
	default
	sed -i "s/'tests'/'tests','examples'/" setup.py || die
}
