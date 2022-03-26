# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Compiling the amalgamation needs a lot of virtual memory
CHECKREQS_MEMORY="300M"

inherit pax-utils toolchain-funcs check-reqs

DESCRIPTION="OpenResty fork of Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="https://github.com/openresty/luajit2"
SRC_URI="https://github.com/openresty/luajit2/archive/refs/tags/v${PV//_p/-}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="lua52compat +optimization static-libs"

HTML_DOCS=( "doc/." )

pkg_pretend() {
	use optimization && check-reqs_pkg_pretend
}

pkg_setup() {
	use optimization && check-reqs_pkg_setup
}

S="${WORKDIR}/luajit2-${PV//_p/-}"

_emake() {
	emake \
		Q= \
		PREFIX="${EPREFIX}/usr" \
		MULTILIB="$(get_libdir)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		DESTDIR="${D}" \
		HOST_CC="$(tc-getBUILD_CC)" \
		HOST_CFLAGS="${BUILD_CPPFLAGS} ${BUILD_CFLAGS}" \
		HOST_LDFLAGS="${BUILD_LDFLAGS}" \
		STATIC_CC="$(tc-getCC)" \
		DYNAMIC_CC="$(tc-getCC) -fPIC" \
		TARGET_LD="$(tc-getCC)" \
		TARGET_CFLAGS="${CPPFLAGS} ${CFLAGS}" \
		TARGET_LDFLAGS="${LDFLAGS}" \
		TARGET_AR="$(tc-getAR) rcus" \
		BUILDMODE="$(usex static-libs mixed dynamic)" \
		TARGET_STRIP="true" \
		INSTALL_LIB="${ED}/usr/$(get_libdir)" \
		"$@"
}

src_compile() {
	local opt xcflags;
	use optimization && opt="amalg";

	xcflags=(
		$(usex lua52compat "-DLUAJIT_ENABLE_LUA52COMPAT" "")
		$(usex amd64 "-DLUAJIT_ENABLE_GC64" "")
		$(usex arm64 "-DLUAJIT_ENABLE_GC64" "")
	)

	tc-export_build_env
	_emake XCFLAGS="${xcflags[*]}" $opt
}

src_install() {
	_emake install
#    dosym "${ED}/usr/bin/${P}" /usr/bin/luajit
	pax-mark m "${ED}/usr/bin/${P}"

#	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" PREREL=${PV//*_/-} MULTILIB="$(get_libdir)" LMULTILIB="$(get_libdir)" install
#	host-is-pax && pax-mark m "${D}/usr/bin/${P}"

	einstalldocs
}
