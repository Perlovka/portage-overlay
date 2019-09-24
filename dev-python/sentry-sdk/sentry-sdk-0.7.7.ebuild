# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy )

inherit distutils-r1

DESCRIPTION="Python client for Sentry"
HOMEPAGE="https://getsentry.com https://pypi.org/project/sentry-sdk/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/urllib3
	dev-python/certifi
"

python_test() {
	if [[ ${EPYTHON} == python2* || ${EPYTHON} == pypy ]]; then
		cd "${S}"/python2 || die
	else
		cd "${S}"/src || die
	fi

	"${PYTHON}" test_typing.py || die "tests failed under ${EPYTHON}"
}
