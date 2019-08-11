# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg

DESCRIPTION="Dwarf management tool for Dwarf Fortress"
HOMEPAGE="https://github.com/Dwarf-Therapist/Dwarf-Therapist"
SRC_URI="https://github.com/Dwarf-Therapist/Dwarf-Therapist/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtdeclarative[widgets]"

DEPEND="${RDEPEND}
	dev-util/cmake
"

S="${WORKDIR}/Dwarf-Therapist-${PV}"

src_prepare() {
	cmake-utils_src_prepare

	# Install docs to a proper location
	sed -i "s#DESTINATION share/doc/dwarftherapist#DESTINATION share/doc/${PF}#" CMakeLists.txt || die
}
