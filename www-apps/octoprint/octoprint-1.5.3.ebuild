# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{7,8})
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit desktop distutils-r1

MY_PN="OctoPrint"

DESCRIPTION="Web interface for 3D printers"
HOMEPAGE="https://github.com/OctoPrint/OctoPrint"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
RESTRICT="primaryuri"
KEYWORDS="~amd64 ~arm ~arm64"

LICENSE="AGPL-3"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}
    acct-group/octoprint
    acct-user/octoprint
    dev-python/pip
    dev-python/octoprint-filecheck
    dev-python/octoprint-firmwarecheck
    dev-python/markupsafe
    www-servers/tornado
    dev-python/markdown
    dev-python/rsa
    dev-python/regex
    dev-python/flask
    dev-python/jinja
    dev-python/flask-assets
    dev-python/flask-babel
    dev-python/flask-login
    dev-python/cachelib
    dev-python/pyyaml
    dev-python/pyserial
    dev-python/netaddr
    dev-python/watchdog
    dev-python/sarge
    dev-python/netifaces
    dev-python/pylru
    dev-python/pkginfo
    dev-python/requests
    dev-python/semantic_version
    dev-python/psutil
    dev-python/feedparser
    dev-python/future
    dev-python/websocket-client
    dev-python/wrapt
    dev-python/emoji
    dev-python/frozendict
    dev-python/sentry-sdk
    dev-python/filetype
    dev-python/zeroconf
    dev-python/unidecode
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

    sed -i 's/markdown>=3.1,<3.2/markdown<3.4/g' setup.py || die
    sed -i 's/zeroconf>=0.24,<0.25/zeroconf<0.29/g' setup.py || die
    sed -i 's/unidecode>=0.04.14,<0.05/unidecode>=0.04.14/g' setup.py || die
    sed -i 's/watchdog==0.10.4/watchdog/g' setup.py || die
    sed -i 's/Flask-Babel>=1.0,<2/Flask-Babel/g' setup.py || die
    sed -i 's/rsa==4.0/rsa/g' setup.py || die
    sed -i 's/tornado==5.1.1/tornado/g' setup.py || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

    newinitd "$FILESDIR/$PN.initd" "$PN"
    newconfd "$FILESDIR/$PN.confd" "$PN"
}
