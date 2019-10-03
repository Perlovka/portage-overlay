# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/arduino/arduino-builder/..."

EGO_VENDOR=(
	"github.com/arduino/arduino-cli 4c32595f712e34ac5af6c52de23f41b6d77b8856"
	"github.com/arduino/go-paths-helper v1.0.1"
	"github.com/arduino/go-properties-orderedmap 05018b28ff6c9492102947be131fd396d74c772e"
	"github.com/arduino/go-timeutils d1dd9e313b1bfede35fe0bbf46d612e16a50e04e"
	"github.com/arduino/go-win32-utils ed041402e83b"
	"github.com/codeclysm/extract v2.2.0"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/go-errors/errors v1.0.1"
	"github.com/golang/protobuf v1.3.2"
	"github.com/pkg/errors v0.8.1"
	"github.com/pmylund/sortutil abeda66eb583"
	"github.com/schollz/closestmatch v2.1.0"
	"github.com/sirupsen/logrus v1.4.2"
	"go.bug.st/cleanup v1.0.0 github.com/bugst/go-cleanup"
	"go.bug.st/downloader v1.1.0 github.com/bugst/go-downloader"
	"go.bug.st/relaxed-semver 0265409c5852 github.com/bugst/relaxed-semver"
	"google.golang.org/genproto d831d65fe17d github.com/google/go-genproto"
	"google.golang.org/grpc v1.21.1 github.com/grpc/grpc-go"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="A command line tool for compiling Arduino sketches"
HOMEPAGE="https://github.com/arduino/arduino-builder"
SRC_URI="https://github.com/arduino/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND=">=dev-lang/go-1.9.2
	dev-go/go-net
	dev-go/go-text"
DEPEND=""
RDEPEND="dev-embedded/arduino-ctags
	dev-embedded/avrdude
	sys-devel/crossdev"

src_unpack() {
	golang-vcs-snapshot_src_unpack
}

src_prepare() {
	default

	# Fix ctags path
	sed -i -e 's@{runtime.tools.ctags.path}@/usr/bin@' -e 's@{path}/ctags@{path}/arduino-ctags@' \
	src/github.com/arduino/arduino-builder/vendor/github.com/arduino/arduino-cli/legacy/builder/ctags/ctags_properties.go || die
}

src_install() {
	# we unfortunately have to copy/paste the contents of golang-build_src_install() here because
	# we *don't* want to call golang_install_pkgs() which installs all static libraries we've
	# built. All we want is to install the final executable.

	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	echo "$@"
	"$@" || die

	# END OF COPY/PASTE

	dobin bin/arduino-builder

	insinto "/usr/share/${PN}"
	cd "src/github.com/arduino/arduino-builder/vendor/github.com/arduino/arduino-cli/legacy/builder/hardware" || die
	doins "platform.keys.rewrite.txt"
}

pkg_postinst() {
	[ ! -x /usr/bin/avr-gcc ] && ewarn "Missing avr-gcc; you need to crossdev -s4 avr"
}
