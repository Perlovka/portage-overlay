# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils mercurial

DESCRIPTION="The glue between Coin3D and Qt"
HOMEPAGE="https://bitbucket.org/Coin3D/soqt"
EHG_REPO_URI="https://bitbucket.org/Coin3D/soqt"
EHG_PROJECT="Coin3D"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc +extra"

RDEPEND=">=media-libs/coin-4
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	virtual/opengl"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog FAQ HACKING NEWS README )

src_configure() {
	local mycmakeargs=(
		-DCOIN_IV_EXTENSIONS=$(usex extra ON OFF)
		-DSOQT_BUILD_DOCUMENTATION=$(usex doc ON OFF)
	)

	cmake-utils_src_configure
}
