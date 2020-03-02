# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit meson multilib-minimal ninja-utils
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
fi

DESCRIPTION="Vulkan-based D3D11 and D3D10 implementation for Linux / Wine"
HOMEPAGE="https://github.com/doitsujin/dxvk"
if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/doitsujin/dxvk.git"
else
	SRC_URI="https://github.com/doitsujin/dxvk/archive/v${PV}.tar.gz"
fi

LICENSE="ZLIB"
SLOT="0"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi
IUSE=""

COMMON_DEPEND="virtual/wine[${MULTILIB_USEDEP}]"
DEPEND="
	${COMMON_DEPEND}
	dev-util/vulkan-headers
	dev-util/glslang
"
RDEPEND="
	${COMMON_DEPEND}
	media-libs/vulkan-loader
"

src_prepare() {
	default
	sed -i "s|^basedir=.*$|basedir=\"${EPREFIX}\"|" setup_dxvk.sh || die
	sed -i 's|"x64"|"usr/lib64/dxvk"|' setup_dxvk.sh || die
	sed -i 's|"x32"|"usr/lib/dxvk"|' setup_dxvk.sh || die

	if ! use abi_x86_64; then
		sed -i '|installFile "$win64_sys_path"|d' setup_dxvk.sh
	fi

	if ! use abi_x86_32; then
		sed -i '|installFile "$win32_sys_path"|d' setup_dxvk.sh
	fi
}

multilib_src_configure() {
	local bit="${MULTILIB_ABI_FLAG:8:2}"
	local emesonargs=(
		--libdir=$(get_libdir)/dxvk
		--bindir=$(get_libdir)/dxvk/bin
		--cross-file=../${P}/build-wine${bit}.txt
	)
	meson_src_configure
}

multilib_src_compile() {
	EMESON_SOURCE="${S}"
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	exeinto /usr/bin
	newexe setup_dxvk.sh dxvk
}

pkg_postinst() {
	elog "dxvk is installed, but not activated. You have to create DLL overrides"
	elog "in order to make use of it. To do so, set WINEPREFIX and execute"
	elog "dxvk install --symlink."
}
