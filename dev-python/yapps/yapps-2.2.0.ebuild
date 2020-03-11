# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Yet Another Python Parser System"
HOMEPAGE="https://github.com/smurfix/yapps/archive/v2.2.0.tar.gz"
SRC_URI="https://github.com/smurfix/yapps/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
