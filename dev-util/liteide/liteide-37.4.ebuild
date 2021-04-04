# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg

DESCRIPTION="LiteIDE is a simple, open source, cross-platform Go IDE"
HOMEPAGE="http://liteide.org"
SRC_URI="https://github.com/visualfc/${PN}/archive/x${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE="gdb"
RESTRICT+=" mirror"

BDEPEND="dev-lang/go
	dev-go/go-tools
"
RDEPEND="${BDEPEND}
	dev-go/gomodifytags
	dev-go/liteide-gocode
	dev-go/liteide-gotools
	dev-qt/qtgui:5
	>=dev-libs/libvterm-0.1.4:=
	gdb? ( sys-devel/gdb )"

S="${WORKDIR}/${PN}-x${PV}/liteidex/"

src_prepare() {
	default
	# unbundle livbterm
	sed -i 's/libvterm/vterm/' src/utils/vterm/vterm.pri || die
	sed -i '/libvterm.pri/d' src/utils/vterm/vterm.pro || die
	sed -i '/libvterm/d' src/3rdparty/3rdparty.pro || die
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr" CONFIG+="release"
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	find "${D}" -name '*.a' -delete || die

	export GOPATH="${S}"

	go run src/tools/exportqrc/main.go -root ./

	dobin liteide/bin/*

	insinto /usr/share/${PN}/
	doins -r deploy/*
	doins -r os_deploy/linux/*

	doicon liteide.png
	make_desktop_entry ${PN} "LiteIDE" "${PN}" "Development;"
}
