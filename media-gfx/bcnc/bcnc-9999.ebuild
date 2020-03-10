# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{6,7})

inherit desktop distutils-r1

DESCRIPTION="GRBL CNC command sender, autoleveler and g-code editor"
HOMEPAGE="https://github.com/vlachoudis/bCNC"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vlachoudis/bCNC.git"
	KEYWORDS="~amd64"
else
	SRC_URI="https://github.com/vlachoudis/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/bCNC-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-lang/python[tk]
	dev-python/numpy
	dev-python/pillow
	dev-python/pyserial
	media-libs/opencv[python]
	sci-libs/scipy
"

src_prepare() {
	default
	sed -i '/opencv-python/d' setup.py || die
	sed -i -e 's/Terminal=true/Terminal=false/' \
			-e '/Path=/d' \
			-e '/Terminal=.*/a Categories=Development;' \
			-e 's/bCNC.png/bCNC/' bCNC/bCNC.desktop || die
	rm -rf tests || die
}

src_install() {
	distutils-r1_src_install
	doicon bCNC/bCNC.png

	insinto /usr/share/applications/
	doins "bCNC/bCNC.desktop"
}
