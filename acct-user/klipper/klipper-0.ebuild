# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/klipper
ACCT_USER_HOME_OWNER=klipper:klipper
ACCT_USER_GROUPS=( klipper uucp )

acct-user_add_deps

KEYWORDS="~amd64 ~arm ~arm64"
