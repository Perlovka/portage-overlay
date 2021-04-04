# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

EGO_SUM=(
"github.com/fatih/camelcase v1.0.0 h1:hxNvNX/xYBp0ovncs8WyWZrOrpBNub/JfaMvbURyft8="
"github.com/fatih/camelcase v1.0.0/go.mod h1:yN2Sb0lFhZJUdVvtELVWefmrXpuZESvPmqwoZc+/fpc="
"github.com/fatih/structtag v1.2.0 h1:/OdNE99OxoI/PqaW/SuSK9uxxT3f/tcSZgon/ssNSx4="
"github.com/fatih/structtag v1.2.0/go.mod h1:mBJUNpUnHmRKrKlQQlmCrh5PuhftFbNv8Ys4/aAZl94="
"golang.org/x/tools v0.0.0-20180824175216-6c1c5e93cdc1 h1:EAPsk8kfGCjxQagrkWjzXlUWe2p3gj5MknO+z2o9GKc="
"golang.org/x/tools v0.0.0-20180824175216-6c1c5e93cdc1/go.mod h1:n7NCudcB/nEzxVGmLbDWY5pfWTLqBcC2KZ6jyYvM4mQ="
)
go-module_set_globals

DESCRIPTION="Go tool to modify/update field tags in structs"
HOMEPAGE="https://github.com/fatih/gomodifytags"

SRC_URI="https://github.com/fatih/gomodifytags/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
${EGO_SUM_SRC_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DOCS=(README.md)

src_compile() {
	GOBIN=${S}/bin \
	go install || die
}

src_install() {
	dobin bin/*
}
