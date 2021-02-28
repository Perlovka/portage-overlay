# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{7,8})
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit desktop distutils-r1

DESCRIPTION="GRBL CNC command sender, autoleveler and g-code editor"
HOMEPAGE="https://github.com/vlachoudis/bCNC"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vlachoudis/bCNC.git"
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi

IUSE="webcam"
LICENSE="GPL-2"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-lang/python[tk]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[tk,${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	webcam? ( media-libs/opencv[python] )
"

src_prepare() {
	default
	sed -i '/opencv-python==/d' setup.py || die
	sed -i -e 's/Terminal=true/Terminal=false/' \
			-e '/Path=/d' \
			-e '/Terminal=.*/a Categories=Development;' \
			-e 's/bCNC.png/bCNC/' bCNC/bCNC.desktop || die
	rm -rf tests || die
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	doicon bCNC/bCNC.png

	insinto /usr/share/applications/
	doins "bCNC/bCNC.desktop"
}
