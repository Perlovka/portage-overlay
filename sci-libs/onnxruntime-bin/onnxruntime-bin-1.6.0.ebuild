# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="cross-platform inference and training machine-learning accelerator"
HOMEPAGE="https://github.com/microsoft/onnxruntime"
SRC_URI="https://github.com/microsoft/onnxruntime/releases/download/v${PV}/onnxruntime-linux-x64-${PV}.tgz"
RESTRICT="primaryuri"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""

S="${WORKDIR}/onnxruntime-linux-x64-${PV}"

src_install() {
	doheader -r include/*.h
	dolib.so lib/libonnxruntime.so*
}
