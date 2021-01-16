# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_PV=$(ver_rs 1 _ ${PV#*.})

DESCRIPTION="A single-player fantasy game"
HOMEPAGE="https://www.bay12games.com/dwarves"
SRC_URI="
	amd64? (
		https://www.bay12games.com/dwarves/df_${MY_PV}_linux.tar.bz2
		dfhack? ( https://github.com/DFHack/dfhack/releases/download/${PV}-r4/dfhack-${PV}-r4-Linux-64bit-gcc-7.tar.bz2 )
	)
	x86? (
		https://www.bay12games.com/dwarves/df_${MY_PV}_linux32.tar.bz2
		dfhack? ( https://github.com/DFHack/dfhack/releases/download/${PV}-r4/dfhack-${PV}-r4-Linux-32bit-gcc-7.tar.bz2 )
	)"

LICENSE="free-noncomm BSD BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dfhack"

RDEPEND="media-libs/glew:0
	media-libs/libsdl[joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	sys-libs/zlib
	virtual/glu
	x11-libs/gtk+:2"
# Yup, libsndfile, openal and ncurses are only needed at compile-time; the code
# dlopens them at runtime if requested.
DEPEND="${RDEPEND}
	media-libs/libsndfile
	media-libs/openal
	virtual/pkgconfig"

S=${WORKDIR}/df_linux

gamesdir="/opt/${PN}"
QA_PREBUILT="${gamesdir#/}/libs/Dwarf_Fortress"
RESTRICT="strip"

src_unpack() {
	local _src_file
	for _src_file in ${A}; do
		if [[ ${_src_file} == dfhack* ]]; then
			mkdir "${S}"/dfhack || die
			cd "${S}"/dfhack || die
			unpack ${_src_file}
		else
			unpack ${_src_file}
		fi
	done
}

src_prepare() {
	default
	rm -f libs/*.so.* || die
	sed -e "s:^src_dir=.*:src_dir=${gamesdir}:" "${FILESDIR}/dwarf-fortress-bin" > dwarf-fortress-bin || die
}

src_install() {

	# install data-files and libs
	insinto "${gamesdir}"
	doins -r raw data libs

	fperms 755 "${gamesdir}"/libs/Dwarf_Fortress

	if use dfhack; then
		doins -r dfhack/*
		fperms 755 "${gamesdir}"/dfhack
		fperms 755 "${gamesdir}"/dfhack-run
		fperms 755 "${gamesdir}"/hack/binpatch
		fperms 755 "${gamesdir}"/hack/dfhack-run
	fi

	# install our wrapper
	dobin dwarf-fortress-bin

	# install docs
	dodoc README.linux *.txt

	doicon "${FILESDIR}"/dwarf-fortress.svg
	make_desktop_entry ${PN} "Dwarf Fortress (Bin)" "dwarf-fortress" "Game;"
}

pkg_postinst() {
	elog "System-wide Dwarf Fortress has been installed to ${gamesdir}. This is"
	elog "copied to ~/.dwarf-fortress when dwarf-fortress is run first time."
	elog "Note: This means that the primary entry point is /usr/bin/dwarf-fortress-bin."
	elog "Do not run ${gamesdir}/libs/Dwarf_Fortress."
	elog
	elog "Optional runtime dependencies:"
	elog "Install sys-libs/ncurses[unicode] for [PRINT_MODE:TEXT]"
	elog "Install media-libs/openal and media-libs/libsndfile for audio output"
	elog "Install media-libs/libsdl[opengl] for the OpenGL PRINT_MODE settings"
}
