# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1 eapi7-ver

MY_BRANCH="$(ver_cut 1-2)"
DESCRIPTION="Settings editor for LightDM GTK+ greeter"
HOMEPAGE="https://launchpad.net/lightdm-gtk-greeter-settings"
SRC_URI="https://launchpad.net/${PN}/${MY_BRANCH}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="${PYTHON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	x11-misc/lightdm-gtk-greeter
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3"
RDEPEND="${DEPEND}"
