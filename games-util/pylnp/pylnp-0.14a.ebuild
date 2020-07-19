# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit desktop python-single-r1 vcs-snapshot xdg

DESCRIPTION="A launcher for Dwarf Fortress"
HOMEPAGE="https://github.com/Pidgeot/python-lnp"
SRC_URI="https://github.com/Pidgeot/python-lnp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="${PYTHON_DEPS}
	>=dev-lang/python-3.6:*[tk]
	media-libs/libsdl[opengl]
"

DEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/pylnp-0.13b-fix-df-directory.patch")

src_prepare() {
	default
	sed -i -e 's/from core/from pylnp.core/' \
		-e '/sys.path.insert/d' launch.py || die
}

src_install() {
	python_newexe launch.py pylnp
	python_moduleinto pylnp
	python_domodule core
	python_domodule tkgui

	insinto "/usr/share/${PN}"
	doins LNPSMALL.png
	doins PyLNP.json

	doicon -s 64 LNP.png
	make_desktop_entry "${PN}" "PyLNP" "LNP" "Game;Utility"
}
