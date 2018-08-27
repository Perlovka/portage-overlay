# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="linotify"

DESCRIPTION="Lua bindings for the Linux inotify library"
HOMEPAGE="https://github.com/hoelzro/linotify"
SRC_URI="https://github.com/hoelzro/linotify/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/lua"

DEPEND="${RDEPEND}
        virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"
