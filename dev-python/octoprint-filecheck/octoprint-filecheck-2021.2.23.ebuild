# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{7,8})
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit desktop distutils-r1

MY_PN="OctoPrint-FileCheck"

DESCRIPTION="The File Check plugin for OctoPrint"
HOMEPAGE="https://github.com/OctoPrint/OctoPrint-FileCheck"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
RESTRICT="primaryuri"
KEYWORDS="~amd64 ~arm ~arm64"

LICENSE="AGPL-3"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_PN}-${PV}"
