# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit desktop flag-o-matic linux-info python-any-r1 toolchain-funcs xdg

MY_PV=${PV/./}

DESCRIPTION="A multi-purpose emulation framework"
HOMEPAGE="https://github.com/mamedev/mame"
SRC_URI="https://github.com/mamedev/mame/archive/refs/tags/mame${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PN}${MY_PV}"

LICENSE="BSD BSD-2 Boost-1.0 CC0-1.0 GPL-2 LGPL-2.1 MIT ZLIB"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~riscv x86"

IUSE="X alsa debug lto opengl openmp pcap pulseaudio qt6 +taptun tools wayland"
IUSE_CPU_FLAGS=" sse2 sse3"
IUSE+=" ${IUSE_CPU_FLAGS// / cpu_flags_x86_}"
IUSE+=" +system-asio +system-expat +system-flac +system-glm +system-jpeg +system-portaudio +system-portmidi"
IUSE+=" +system-pugixml +system-rapidjson +system-sqlite3 +system-utf8proc +system-zlib +system-zstd"

RDEPEND="
	media-libs/fontconfig
	media-libs/libsdl2[joystick,opengl?,sound,video]
	media-libs/sdl2-ttf
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXinerama
	)
	alsa? ( media-libs/alsa-lib )
	opengl? ( virtual/opengl:0 )
	openmp? ( sys-devel/gcc[openmp] )
	pcap? ( net-libs/libpcap )
	pulseaudio? ( media-libs/libpulse )
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	system-asio? ( dev-cpp/asio )
	system-expat? ( dev-libs/expat )
	system-flac? ( media-libs/flac )
	system-glm? ( media-libs/glm )
	system-jpeg? ( media-libs/libjpeg-turbo:= )
	system-portaudio? ( media-libs/portaudio )
	system-portmidi? ( media-libs/portmidi )
	system-pugixml? ( dev-libs/pugixml )
	system-rapidjson? ( dev-libs/rapidjson )
	system-sqlite3? ( dev-db/sqlite:3 )
	system-utf8proc? ( dev-libs/libutf8proc )
	system-zlib? ( sys-libs/zlib )
	system-zstd? ( app-arch/zstd )
	virtual/ttf-fonts
	wayland? ( dev-libs/wayland )
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig"

mame_use() {
	case $1 in
		X)
			use !${1} && echo 'NO_X11=1'
			;;
		amd64)
			use ${1} && echo 'PTR64=1'
			;;
		cpu_flags_x86_*)
			local feature=${1/cpu_flags_x86_/}
			use ${1} && echo "${feature^^}=1"
			;;
		debug | lto | tools)
			use ${1} && echo "${1^^}=1"
			;;
		opengl)
			use !${1} && echo "NO_${1^^}=1"
			;;
		pulseaudio)
			use !${1} && echo "NO_USE_${1^^}=1"
			;;
		system-*)
			local feature=${1/system-/}
			use ${1} && echo "USE_SYSTEM_LIB_${feature^^}=1"
			;;
		*)
			use ${1} && echo "USE_${1^^}=1"
			;;
	esac
}

pkg_setup() {
	python-any-r1_pkg_setup

	if use taptun; then
		linux-info_pkg_setup
		local CONFIG_CHECK
		CONFIG_CHECK="TAP TUN"
		check_extra_config
	fi
}

PATCHES=( "${FILESDIR}/${PN}-sse3-support.patch" )

src_prepare() {
	default

	sed -i \
		-e 's/-Os//' \
		-e '/^\(CC\|CXX\|AR\) /s/=/?=/' \
		3rdparty/genie/build/gmake.linux/genie.make || die

	# Optimization flag was handled via OPTIMIZE variable
	filter-flags '-O?'
}

src_compile() {
	# $ARCH variable in mame build scripts
	# conflicts with Gentoo's portage system
	emake \
		ARCH= \
		EMULATOR=1 \
		IGNORE_GIT=1 \
		NOWERROR=1 \
		OPTIMIZE=3 \
		OVERRIDE_AR=$(tc-getAR) \
		OVERRIDE_CC=$(tc-getCC) \
		OVERRIDE_CXX=$(tc-getCXX) \
		OVERRIDE_LD=$(tc-getLD) \
		PYTHON_EXECUTABLE=${PYTHON} \
		QT_HOME="/usr/$(get_libdir)/qt$(usex qt6 "6" "5")" \
		REGENIE=1 \
		SDL_INI_PATH="\$\$\$\$HOME/.mame;/etc/${PN}" \
		VERBOSE=1 \
		$(mame_use X) \
		$(mame_use amd64) \
		$(mame_use cpu_flags_x86_sse2) \
		$(mame_use cpu_flags_x86_sse3) \
		$(mame_use debug) \
		$(mame_use lto) \
		$(mame_use tools) \
		$(mame_use opengl) \
		$(mame_use openmp) \
		$(mame_use pcap) \
		$(mame_use pulseaudio) \
		$(mame_use taptun) \
		$(mame_use wayland) \
		$(mame_use system-asio) \
		$(mame_use system-expat) \
		$(mame_use system-flac) \
		$(mame_use system-glm) \
		$(mame_use system-jpeg) \
		$(mame_use system-portaudio) \
		$(mame_use system-portmidi) \
		$(mame_use system-pugixml) \
		$(mame_use system-rapidjson) \
		$(mame_use system-sqlite3) \
		$(mame_use system-utf8proc) \
		$(mame_use system-zlib) \
		$(mame_use system-zstd)
}

src_install() {
	MAMEBIN=${PN}
	dobin ${MAMEBIN}
	doman docs/man/mame.6

	insinto "/usr/share/${PN}"
	doins -r artwork bgfx ctrlr hash language keymaps plugins

	insinto "/usr/share/${PN}/shader"
	doins src/osd/modules/opengl/shader/glsl*.*h

	./${MAMEBIN} -noreadconfig -showconfig > "${T}/${PN}.ini" || die

	for f in art ctrlr hash language;do
		sed -i "s#\(^${f}path[ ]*\)\([./a-zA-Z]*\)#\1\$HOME/.${PN}/\2;/usr/share/${PN}/\2#" "${T}/${PN}.ini" || die
	done

	sed -i "s#\(^bgfx_path[ ]*\)\([./a-zA-Z]*\)#\1/usr/share/${PN}/\2#" "${T}/${PN}.ini" || die
	sed -i "s#\(^homepath[ ]*\)[./a-zA-Z]*#\1\$HOME/.${PN}#" "${T}/${PN}.ini" || die

	for f in rom sample; do
		sed -i "s#\(^${f}path[ ]*\)\([./a-zA-Z]*\)#\1\$HOME/.${PN}/\2#" "${T}/${PN}.ini" || die
	done

	for f in cfg comment diff input nvram share snapshot state; do
		sed -i "s#\(^${f}_directory[ ]*\)\([./a-zA-Z]*\)#\1\$HOME/.${PN}/\2#" "${T}/${PN}.ini" || die
	done

	sed -i "s#\(^pluginspath[ ]*\)\([./a-zA-Z]*\)#\1/usr/share/${PN}/\2#" "${T}/${PN}.ini" || die

	insinto "/etc/${PN}"
	doins "${T}/${PN}.ini"

	make_desktop_entry ${PN}
	doicon -s scalable "${FILESDIR}/${PN}.svg"

	if use tools; then
		for f in castool chdman floptool imgtool jedutil ldplayer ldresample ldverify romcmp; do
			newbin ${f} ${PN}-${f}
			newman docs/man/${f}.1 ${PN}-${f}.1
		done
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "It is strongly recommended to change either the system wide"
	elog " /etc/${PN}/${PN}.ini or use a per-user setup at ~/.${PN}/${PN}.ini"
	elog

	if use opengl; then
		elog "You built ${PN} with opengl support and should set"
		elog "\"video\" to \"opengl\" in ${PN}.ini to take advantage of that"
		elog
		elog "See https://wiki.mamedev.org for more information."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
