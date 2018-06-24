# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils qmake-utils

DESCRIPTION="LiteIDE is a simple, open source, cross-platform Go IDE"
HOMEPAGE="http://liteide.org"
SRC_URI="https://github.com/visualfc/${PN}/archive/x${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE="gdb"
RESTRICT+=" mirror"

DEPEND="dev-lang/go
	dev-go/go-tools
	dev-qt/qtgui:5"
RDEPEND="${DEPEND}
	gdb? ( sys-devel/gdb )"

S="${WORKDIR}/${PN}-x${PV}/liteidex/"

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr" CONFIG+="release"
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	find "${D}" -name '*.a' -delete || die

	export GOPATH="${S}"

	go get github.com/visualfc/gotools
	go get github.com/nsf/gocode
	go get github.com/fatih/gomodifytags
	go run src/tools/exportqrc/main.go -root ./

	dobin bin/*

	insinto /usr/share/${PN}/
	doins -r deploy/*
	doins -r os_deploy/linux/*

	doicon liteide.png
	make_desktop_entry ${PN} "LiteIDE" "${PN}" "Development;"
}
