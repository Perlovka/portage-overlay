# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy )

inherit distutils-r1

DESCRIPTION="wrapper for subprocess which provides command pipeline functionality"
HOMEPAGE="http://sarge.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.post0.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND=""
BDEPEND=""

S="${WORKDIR}/${P}.post0"
#src_prepare() {
#    default
#    sed -i '/long_description=description().*/d' setup.py || die
#}
