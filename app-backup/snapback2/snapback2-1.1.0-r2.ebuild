# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_NAME=Snapback2
DIST_AUTHOR=MIKEH
DIST_VERSION=1.001
inherit perl-module

DESCRIPTION="Routines for support of rsync-based snapshot backup"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Config-ApacheFormat"

PATCHES=(
	"${FILESDIR}/${P}-dotinc.patch"
)
