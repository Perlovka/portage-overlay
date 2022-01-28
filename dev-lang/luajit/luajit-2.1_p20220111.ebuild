# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Compiling the amalgamation needs a lot of virtual memory
CHECKREQS_MEMORY="300M"

inherit pax-utils toolchain-funcs flag-o-matic check-reqs

DESCRIPTION="OpenResty fork of Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="https://github.com/openresty/luajit2"
SRC_URI="https://github.com/openresty/luajit2/archive/refs/tags/v${PV//_p/-}.tar.gz -> ${P}.tar.gz"

SLOT="2"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="lua52compat +optimization static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

HTML_DOCS=( "doc/." )

pkg_pretend() {
	use optimization && check-reqs_pkg_pretend
}

pkg_setup() {
	use optimization && check-reqs_pkg_setup
}

S="${WORKDIR}/luajit2-${PV//_p/-}"

src_compile() {
	local opt xcflags;
	use optimization && opt="amalg";

	tc-export CC

	xcflags=(
		$(usex lua52compat "-DLUAJIT_ENABLE_LUA52COMPAT" "")
		$(usex amd64 "-DLUAJIT_ENABLE_GC64" "")
		$(usex arm64 "-DLUAJIT_ENABLE_GC64" "")
	)

	emake \
		Q= \
		PREFIX="${EPREFIX}/usr" \
		BUILDMODE="$(usex static-libs mixed dynamic)" \
		HOST_CC="$(tc-getCC)" \
        DYNAMIC_CC="$(tc-getCC) -fPIC" \
        STATIC_CC="$(tc-getCC)" \
        TARGET_AR="$(tc-getAR) rcus" \
        TARGET_LD="$(tc-getCC)" \
		TARGET_STRIP="true" \
		MULTILIB="$(get_libdir)" \
		LMULTILIB="$(get_libdir)" \
		XCFLAGS="${xcflags[*]}" ${opt}
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" PREREL=${PV//*_/-} MULTILIB="$(get_libdir)" LMULTILIB="$(get_libdir)" install

	einstalldocs

	host-is-pax && pax-mark m "${D}/usr/bin/${P}"
}
