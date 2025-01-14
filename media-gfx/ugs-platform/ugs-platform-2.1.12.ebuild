# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop

DESCRIPTION="Universal G-Code Sender is a cross platform G-Code sender, compatible with GRBL"
HOMEPAGE="https://github.com/winder/Universal-G-Code-Sender"
SRC_URI="https://github.com/winder/Universal-G-Code-Sender/releases/download/v${PV}/${PN}-app-${PV}.zip"
S="${WORKDIR}/ugsplatform"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"
RESTRICT="primaryuri"

BDEPEND="app-arch/unzip"
RDEPEND="dev-java/openjdk-jre-bin:17"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	rm -rf "${S}"/platform/modules/lib/{aarch64,i386,riscv64} || die
}

src_install() {
	insinto "/opt/${PN}"
	doins -r ./

	dobin "${FILESDIR}/ugs-platform"
	doicon "${FILESDIR}/${PN}.svg"

	make_desktop_entry "${PN}" "UGS Platform" "${PN}" "Electronics;Science"
}
