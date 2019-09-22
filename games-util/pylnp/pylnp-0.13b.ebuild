# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit desktop python-single-r1 vcs-snapshot xdg

DESCRIPTION="Cross-platform re-implementation of the Lazy Newb Pack launcher"
HOMEPAGE="https://bitbucket.org/Pidgeot/python-lnp"
SRC_URI="https://bitbucket.org/Pidgeot/python-lnp/get/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
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

#python_prepare_all() {
#	! use test && export PYTEST_RUNNER='false'
#	distutils-r1_python_prepare_all
#}

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
