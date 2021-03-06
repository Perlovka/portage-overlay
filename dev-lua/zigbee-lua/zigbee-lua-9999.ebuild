# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 toolchain-funcs user

EGIT_SUBMODULES=()

DESCRIPTION="A Zigbee control framework written in Lua"
HOMEPAGE="https://github.com/hwhw/zigbee-lua"
EGIT_REPO_URI="https://github.com/hwhw/zigbee-lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/lua:=
	dev-lua/inspect
	dev-lua/libmicrohttpd-ffi
	dev-lua/libmosquitto-ffi
	dev-lua/lua-cjson
	dev-lua/ljsyscall"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	enewgroup zigbee
	enewuser zigbee -1 -1 "/var/lib/${PN}" "zigbee,uucp"
}

src_prepare() {
	default

#    sed  "/^#!.*/a package.path='/usr/share/lua/5.1/${PN}/?.lua;/etc/zigbee-lua/?.lua;' .. package.path" main.lua > zigbee-lua || die

	sed -i "s#device_database.json#/var/lib/${PN}/device_database.json#" config.lua || die

	sed -i 's/require"lib.ljsyscall"/require"syscall"/' lib/*.lua || die
	sed -i 's/require"lib.ljsyscall"/require"syscall"/' interfaces/*.lua || die
	sed -i 's/require"lib.ljsyscall"/require"syscall"/' interfaces/zigbee/devices/*.lua || die

	sed -i 's/lib.inspect-lua.inspect/inspect/' lib/util.lua || die
	sed -i 's/require"lib.json-lua.json"/require"cjson"/' interfaces/zigbee.lua || die
	sed -i -e 's/require"lib.json-lua.json"/require"cjson"/' \
		-e 's/lib.ffi_libmosquitto.mosquitto/mosquitto/'  interfaces/mqtt_client.lua || die

	rm lib/ljsyscall.lua || die
}

src_install() {

	local lua_path="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"

	dosbin "${FILESDIR}"/${PN}

	insinto "/etc/${PN}/"
	doins ./config.lua

	insinto "$lua_path/${PN}"
	doins -r ./interfaces

	insinto "$lua_path/${PN}/lib"
	doins ./lib/*.lua

	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	dodoc README.TXT
}
