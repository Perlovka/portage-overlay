# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6}  )

inherit mercurial distutils-r1

DESCRIPTION="Coin3d binding for Python"
HOMEPAGE="https://bitbucket.org/Coin3D/pivy"
EHG_REPO_URI="https://bitbucket.org/Coin3D/pivy"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""

RDEPEND="
	media-libs/SoQt
"
DEPEND="${RDEPEND}
	dev-lang/swig
"
