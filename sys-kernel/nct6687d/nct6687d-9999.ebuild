# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Nuvoton NCT6687 kernel module"
HOMEPAGE="https://github.com/Fred78290/nct6687d"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Fred78290/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

src_compile() {
	local modlist=( nct6687=kernel/drivers/hwmon )
	local modargs=( KDIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}

src_prepare() {
	default
	cp "$FILESDIR/Makefile" "$S" || die "Makefile replacing failed"
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst
}
