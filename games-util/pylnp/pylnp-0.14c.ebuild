# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10,11} )

inherit desktop python-single-r1 python-utils-r1 vcs-snapshot xdg

DESCRIPTION="A launcher for Dwarf Fortress"
HOMEPAGE="https://github.com/Pidgeot/python-lnp"
SRC_URI="https://github.com/Pidgeot/python-lnp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="${PYTHON_DEPS}
	dev-lang/python:*[tk]
	media-libs/libsdl[opengl]
"

DEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/pylnp-0.14c-fix-df-directory.patch")

src_prepare() {
	default
    sed -i -e '/sys.path.insert/d' \
            -e "/^import sys/a sys.path.insert(0, os.path.join(\"$(python_get_sitedir)\", \"${PN}\"))" \
            launch.py || die
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
