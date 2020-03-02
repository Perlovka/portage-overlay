# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit multilib-minimal

DESCRIPTION="Vulkan-based D3D11 and D3D10 implementation for Linux / Wine"
HOMEPAGE="https://github.com/doitsujin/dxvk"
SRC_URI="https://github.com/doitsujin/dxvk/releases/download/v${PV}/dxvk-${PV}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	virtual/wine[${MULTILIB_USEDEP}]
	media-libs/vulkan-loader
"

S="${WORKDIR}/dxvk-${PV}"

src_prepare() {
	default
	sed -i 's#^basedir=.*$#basedir="/opt/dxvk"#' setup_dxvk.sh || die

	if ! use abi_x86_64; then
		sed -i '/installFile "$win64_sys_path"/d' setup_dxvk.sh
	fi

	if ! use abi_x86_32; then
		sed -i '/installFile "$win32_sys_path"/d' setup_dxvk.sh
	fi
}

src_install() {
	insinto /opt/dxvk
	doins -r x32
	doins -r x64

	exeinto /opt/bin
	newexe setup_dxvk.sh dxvk-bin
}

pkg_postinst() {
	elog "dxvk is installed, but not activated. You have to create DLL overrides"
	elog "in order to make use of it. To do so, set WINEPREFIX and execute"
	elog "dxvk-bin install --symlink"
}
