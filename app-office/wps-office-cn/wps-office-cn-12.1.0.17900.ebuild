# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker xdg

MY_PN="${PN/-cn}"
MY_PV="$(ver_cut 4)"

DESCRIPTION="WPS Office is an office productivity suite"
HOMEPAGE="https://linux.wps.cn"
SRC_URI="amd64? ( https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2023/${MY_PV}/${MY_PN}_${PV}_amd64.deb )"
S="${WORKDIR}"

LICENSE="WPS-EULA"
SLOT="0"

KEYWORDS="~amd64"
IUSE="systemd"

RESTRICT="bindist strip mirror" # mirror as explained at bug #547372
QA_PREBUILT="*"

# Deps got from this (listed in order):
# rpm -qpR wps-office-10.1.0.5707-1.a21.x86_64.rpm
# ldd /opt/kingsoft/wps-office/office6/wps
# ldd /opt/kingsoft/wps-office/office6/wpp
RDEPEND="
	app-arch/bzip2:0
	app-arch/lz4
	app-arch/xz-utils
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libbsd
	dev-libs/libffi:0/8
	dev-libs/libgcrypt:0
	dev-libs/libgpg-error
	dev-libs/libpcre:3
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/flac:=
	media-libs/libogg
	media-libs/libpulse
	media-libs/libsndfile
	media-libs/libvorbis
	media-libs/tiff-compat:4
	net-libs/libasyncns
	net-print/cups
	sys-apps/attr
	sys-apps/tcp-wrappers
	sys-apps/util-linux
	sys-libs/libcap
	llvm-runtimes/libcxx
	sys-libs/zlib:0
	virtual/glu
	x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	systemd? ( sys-apps/systemd )
	!${CATEGORY}/${MY_PN}
"

pkg_nofetch() {
	elog "Please visit https://linux.wps.cn and download ${MY_PN}_${PV}_amd64.deb"
	elog "into your DISTDIR directory."
}

src_install() {
	# https://bugs.gentoo.org/878451
	rm "${S}"/opt/kingsoft/wps-office/office6/libstdc++.so* || die

	# https://bugs.gentoo.org/813138
	use systemd || { rm "${S}"/opt/kingsoft/wps-office/office6/libdbus-1.so* || die ; }

	exeinto /usr/bin
	exeopts -m0755
	doexe "${S}"/usr/bin/*

	insinto /usr/share
	# Skip mime subdir to not get selected over rest of office suites
	doins -r "${S}"/usr/share/{applications,desktop-directories,icons,templates}

	insinto /opt/kingsoft/wps-office
	doins -r "${S}"/opt/kingsoft/wps-office/{office6,templates}

	fperms 0755 /opt/kingsoft/wps-office/office6/{wps,wpp,et,wpspdf,wpsoffice,promecefpluginhost,transerr,ksolaunch,wpscloudsvr}
}
