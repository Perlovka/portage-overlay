# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="An OSS column-oriented database management system for real-time data analysis"
HOMEPAGE="https://clickhouse.com/"

SRC_URI="https://github.com/ClickHouse/ClickHouse/releases/download/v${PV}-lts/clickhouse-common-static-${PV}-amd64.tgz
	server? ( https://github.com/ClickHouse/ClickHouse/releases/download/v${PV}-lts/clickhouse-server-${PV}-amd64.tgz )
	client?	( https://github.com/ClickHouse/ClickHouse/releases/download/v${PV}-lts/clickhouse-client-${PV}-amd64.tgz )
"

S="${WORKDIR}/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+client +server"
RESTRICT="primaryuri"
QA_PRESTRIPPED="/usr/bin/clickhouse /usr/bin/clickhouse-library-bridge /usr/bin/clickhouse-odbc-bridge"

REQUIRED_USE="
	|| ( client server )
"

DEPEND="
	acct-group/clickhouse
	acct-user/clickhouse
"
RDEPEND="${DEPEND}"

src_install() {
	dobin clickhouse-common-static-${PV}/usr/bin/clickhouse
	dosym clickhouse /usr/bin/clickhouse-extract-from-config

	if use client; then
		doins -r clickhouse-client-${PV}/etc
		insinto /usr/bin
		doins clickhouse-client-${PV}/usr/bin/*
	fi

	if use server; then
		insinto /etc
		doins -r clickhouse-server-${PV}/etc/clickhouse-server
		insinto /usr/bin
		doins clickhouse-server-${PV}/usr/bin/*

		newinitd "${FILESDIR}"/clickhouse-server.initd clickhouse-server
		systemd_dounit "${FILESDIR}"/clickhouse-server.service

		keepdir /var/log/clickhouse-server

	fi
}

pkg_preinst() {
	if use server; then
		fowners clickhouse:clickhouse /var/log/clickhouse-server
	fi
}
