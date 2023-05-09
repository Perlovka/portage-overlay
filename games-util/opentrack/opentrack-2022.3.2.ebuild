# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

DESCRIPTION="Head tracking software for MS Windows, Linux, and Apple OSX"
HOMEPAGE="https://github.com/opentrack/opentrack"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/opentrack/opentrack.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${P}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+opencv wine"
RESTRICT="primaryuri"

DEPEND="
	opencv? (
		media-libs/opencv[v4l]
	)
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/linguist-tools:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	~sci-libs/onnxruntime-bin-1.6.0
"

RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s|share/doc/opentrack|share/doc/${P}|" -i cmake/opentrack-hier.cmake
	if [[ ${PV} != "9999" ]]; then
		mkdir "${S}/presets" || die
		eapply "$FILESDIR/respect_destdir_for_presets.patch"
		eapply "$FILESDIR/fix_nn_tracker.patch"
	fi

	eapply "$FILESDIR/fix_i18n.patch"
	cmake_src_prepare
	xdg_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release \
		-DSDK_WINE=$(usex wine) \
		-DONNXRuntime_ROOT="/usr/$(get_libdir)"
	)
	cmake_src_configure
}

src_install() {
	make_desktop_entry opentrack OpenTrack opentrack ""
	doicon -s 24 "gui/images/${PN}.png"

	cmake_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
