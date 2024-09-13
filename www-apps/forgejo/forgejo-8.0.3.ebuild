# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps go-module tmpfiles systemd flag-o-matic

DESCRIPTION="A self-hosted lightweight software forge"
HOMEPAGE="https://forgejo.org/ https://codeberg.org/forgejo/forgejo"

SRC_URI="https://codeberg.org/forgejo/forgejo/releases/download/v${PV}/forgejo-src-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-src-${PV}"
LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

IUSE="+acct pam sqlite pie"

DEPEND="
	acct? (
		acct-group/git
		acct-user/git[forgejo] )
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}
	dev-vcs/git"

DOCS=(
	custom/conf/app.example.ini CONTRIBUTING.md README.md
)

FILECAPS=(
	-m 711 cap_net_bind_service+ep usr/bin/forgejo
)

RESTRICT="test"

src_prepare() {
	default

	local sedcmds=(
		-e "s#^ROOT =#ROOT = ${EPREFIX}/var/lib/forgejo/forgejo-repositories#"
		-e "s#^ROOT_PATH =#ROOT_PATH = ${EPREFIX}/var/log/forgejo#"
		-e "s#^APP_DATA_PATH = data#APP_DATA_PATH = ${EPREFIX}/var/lib/forgejo/data#"
		-e "s#^HTTP_ADDR = 0.0.0.0#HTTP_ADDR = 127.0.0.1#"
		-e "s#^MODE = console#MODE = file#"
		-e "s#^LEVEL = Trace#LEVEL = Info#"
		-e "s#^LOG_SQL = true#LOG_SQL = false#"
		-e "s#^DISABLE_ROUTER_LOG = false#DISABLE_ROUTER_LOG = true#"
	)

	sed -i "${sedcmds[@]}" custom/conf/app.example.ini || die
	if use sqlite ; then
		sed -i -e "s#^DB_TYPE = .*#DB_TYPE = sqlite3#" custom/conf/app.example.ini || die
	fi
}

src_configure() {
	# bug 832756 - PIE build issues
	filter-flags -fPIE
	filter-ldflags -fPIE -pie
}

src_compile() {
	local forgejo_tags=(
		bindata
		$(usev pam)
		$(usex sqlite 'sqlite sqlite_unlock_notify' '')
	)
	local forgejo_settings=(
		"-X code.gitea.io/gitea/modules/setting.CustomConf=${EPREFIX}/etc/forgejo/app.ini"
		"-X code.gitea.io/gitea/modules/setting.CustomPath=${EPREFIX}/var/lib/forgejo/custom"
		"-X code.gitea.io/gitea/modules/setting.AppWorkPath=${EPREFIX}/var/lib/forgejo"
	)
	local makeenv=(
		DRONE_TAG="${PV}"
		LDFLAGS="-extldflags \"${LDFLAGS}\" ${forgejo_settings[*]}"
		TAGS="${forgejo_tags[*]}"
	)

	GOFLAGS=""
	if use pie ; then
		GOFLAGS+="-buildmode=pie"
	fi

	# need to set -j1 or build fails due to a race condition between MAKE jobs.
	# this does not actually impact build parallelism, because the go compiler
	# will still build everything in parallel when it's invoked.
	env "${makeenv[@]}" emake -j1 EXTRA_GOFLAGS="${GOFLAGS}" backend
}

src_install() {
	cp gitea forgejo
	dobin forgejo

	einstalldocs

	newconfd "${FILESDIR}/forgejo.confd" forgejo
	newinitd "${FILESDIR}/forgejo.initd" forgejo
	newtmpfiles - forgejo.conf <<-EOF
		d /run/forgejo 0755 git git
	EOF
	systemd_newunit "${FILESDIR}"/forgejo.service forgejo.service

	insinto /etc/forgejo
	newins custom/conf/app.example.ini app.ini
	if use acct; then
		fowners root:git /etc/forgejo/{,app.ini}
		fperms g+w,o-rwx /etc/forgejo/{,app.ini}

		diropts -m0750 -o git -g git
		keepdir /var/lib/forgejo /var/lib/forgejo/custom /var/lib/forgejo/data
		keepdir /var/log/forgejo
	fi
}

pkg_postinst() {
	fcaps_pkg_postinst
	tmpfiles_process forgejo.conf

	ewarn "> MySQL 8.0 or PostgreSQL 12 are the minimum supported versions. The"
	ewarn "> database must be migrated before upgrading. The requirements"
	ewarn "> regarding SQLite did not change."
	ewarn ">"
	ewarn "> The Gitea themes were renamed and the [ui].THEMES setting must be changed as follows:"
	ewarn "> - gitea is replaced by gitea-light"
	ewarn "> - arc-green is replaced by gitea-dark"
	ewarn "> - auto is replaced by gitea-auto"
	ewarn ""
	ewarn "See https://codeberg.org/forgejo/forgejo/src/branch/forgejo/RELEASE-NOTES.md#7-0-0"
	ewarn "for more information"
}
