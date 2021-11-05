# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 gnome2-utils

DESCRIPTION="An open-source AVR electronics prototyping platform"
HOMEPAGE="https://arduino.cc/ https://github.com/arduino/"

AVR_VERSION="1.8.3"
PLUGIN_VERSION="0.12.0"
EXAMPLES_VERSION="1.9.1"

SRC_URI="https://github.com/arduino/Arduino/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/arduino/arduino-examples/archive/${EXAMPLES_VERSION}.zip -> ${PN}-examples-${EXAMPLES_VERSION}.zip
	https://downloads.arduino.cc/cores/avr-${AVR_VERSION}.tar.bz2 -> ${PN}-avr-${AVR_VERSION}.tar.bz2
	https://github.com/arduino-libraries/WiFi101-FirmwareUpdater-Plugin/releases/download/v${PLUGIN_VERSION}/WiFi101-Updater-ArduinoIDE-Plugin-${PLUGIN_VERSION}.zip -> ${PN}-WiFi101-Updater-ArduinoIDE-Plugin-${PLUGIN_VERSION}.zip
"

LICENSE="GPL-2 LGPL-2.1 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

CDEPEND="dev-embedded/arduino-builder"

BDEPEND="doc? ( app-text/asciidoc )"

RDEPEND="${CDEPEND}
	>=dev-util/astyle-3.1[java]
	dev-embedded/arduino-listserialportsc
	>=virtual/jre-1.8"

DEPEND="${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.8"

EANT_BUILD_TARGET="build"
# don't run the default "javadoc" target, we don't have one.
EANT_DOC_TARGET=""
EANT_BUILD_XML="build/build.xml"
EANT_EXTRA_ARGS=" -Dlight_bundle=1 -Dlocal_sources=1 -Dno_arduino_builder=1 -Dversion=${PV}"

RESTRICT="strip"
QA_PREBUILT="usr/share/arduino/hardware/arduino/avr/firmwares/*"

S="${WORKDIR}/Arduino-${PV}"

PATCHES=(
	# We need to load system astyle/listserialportsc instead of bundled ones.
	"${FILESDIR}/${PN}-1.8.5-lib-loading.patch"
	"${FILESDIR}/${PN}-1.8.16-xdg-compliance.patch"
)

src_unpack() {
	# We don't want to unpack tools, just move zip files into the work dir
	local a=( ${A} )
	unpack "${a[0]}"

	cp "${DISTDIR}/${PN}-avr-${AVR_VERSION}.tar.bz2" "${S}/build/avr-${AVR_VERSION}.tar.bz2" || die
	cp "${DISTDIR}/${PN}-WiFi101-Updater-ArduinoIDE-Plugin-${PLUGIN_VERSION}.zip" "${S}/build/shared/WiFi101-Updater-ArduinoIDE-Plugin-${PLUGIN_VERSION}.zip" || die
	cp "${DISTDIR}/${PN}-examples-${EXAMPLES_VERSION}.zip" "${S}/build/" || die
}

src_prepare() {
	default

	# Unbundle libastyle
	sed -i 's/\(target name="linux-libastyle-[a-zA-Z0-9]*"\)/\1 if="never"/g' "$S/build/build.xml" || die

	# Unbundle avr toolchain
	sed -i 's/target name="avr-toolchain-bundle" unless="light_bundle"/target name="avr-toolchain-bundle" if="never"/' "$S/build/build.xml" || die

	# Install avr hardware
	sed -i 's/target name="assemble-hardware" unless="light_bundle"/target name="assemble-hardware"/' "$S/build/build.xml" || die
}

src_compile() {
	java-pkg-2_src_compile
	/usr/bin/a2x -f manpage "${S}"/build/shared/manpage.adoc || die
}

src_install() {
	cd "${S}"/build/linux/work || die

	# We need to replace relative paths for toolchain executable by paths to system ones.
	sed -i -e 's@^compiler.path=.*@compiler.path=/usr/bin/@' -e 's@^tools.avrdude.path=.*@tools.avrdude.path=/usr@' \
		-e 's@^tools.avrdude.config.path=.*@tools.avrdude.config.path=/etc/avrdude.conf@' hardware/arduino/avr/platform.txt || die

	java-pkg_dojar lib/*.jar
	java-pkg_dolauncher ${PN} \
		--pwd "/usr/share/${PN}" \
		--main "processing.app.Base" \
		--java_args "-DAPP_DIR=/usr/share/${PN} -Djava.library.path=${EPREFIX}/usr/$(get_libdir)"

	insinto "/usr/share/${PN}"

	doins -r examples hardware lib tools

	# In upstream's build process, we copy these fiels below from the bundled arduino-builder.
	# Here we do the same thing, but from the system arduino-builder.
	dosym "../../arduino-builder/platform.txt" "/usr/share/${PN}/hardware/platform.txt"
	dosym "../../arduino-builder/platform.keys.rewrite.txt" "/usr/share/${PN}/hardware/platform.keys.rewrite.txt"
	dosym "../../bin/arduino-builder" "/usr/share/${PN}/arduino-builder"

	# hardware/tools/avr needs to exist or arduino-builder will
	# complain about missing required -tools arg
	dodir "/usr/share/${PN}/hardware/tools/avr"

	# Install menu and icons
	domenu "${FILESDIR}/${PN}.desktop"
	cd lib/icons || die
	local icondir
	for icondir in *; do
		# icondir name is something like "24x24" we want the "24" part
		local iconsize=`cut -dx -f1 <<< "${icondir}"`
		newicon -s $iconsize \
			"${icondir}/apps/arduino.png" \
			"${PN}.png"
	done

	doman "${S}"/build/shared/arduino.1
}

pkg_postinst() {
	gnome2_icon_cache_update
	[[ ! -x /usr/bin/avr-g++ ]] && ewarn "Missing avr-g++; you need to crossdev -s4 avr"
}
