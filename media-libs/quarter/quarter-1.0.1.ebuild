# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Coin GUI binding for Qt"
HOMEPAGE="https://bitbucket.org/Coin3D/quarter"
SRC_URI="https://bitbucket.org/Coin3D/quarter/downloads/${P}-src.zip"
RESTRICT="primaryuri"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="designer doc examples"

RDEPEND=">=media-libs/coin-4
	dev-qt/qtopengl:5"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}"

src_configure() {
	local mycmakeargs=(
		-DQUARTER_BUILD_PLUGIN=$(usex designer ON OFF)
		-DQUARTER_BUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DQUARTER_BUILD_EXAMPLES=$(usex examples ON OFF)
	)

	cmake-utils_src_configure
}
