# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Wemeet - Tencent Video Conferencing"
HOMEPAGE="https://wemeet.qq.com"
SRC_URI="
	amd64? ( https://updatecdn.meeting.qq.com/cos/fb7464ffb18b94a06868265bed984007/TencentMeeting_0300000000_${PV}_x86_64_default.publish.officialwebsite.deb )
	arm64? ( https://updatecdn.meeting.qq.com/cos/fb7464ffb18b94a06868265bed984007/TencentMeeting_0300000000_${PV}_x86_64_default.publish.officialwebsite.deb )
	loong? ( https://updatecdn.meeting.qq.com/cos/f631206473dc463a64709ee1c741e2b8/TencentMeeting_0300000000_${PV}_loongarch64_default.publish.officialwebsite.deb )
"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64 ~loong"
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/expat
	dev-libs/glib
	dev-libs/libffi
	dev-libs/libpcre2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libglvnd
	media-libs/libpng
	media-libs/libpulse
	sys-apps/dbus
	sys-apps/systemd
	sys-apps/util-linux
	sys-libs/libcap
	sys-libs/libunwind
	sys-libs/zlib
	x11-libs/libdrm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXtst
"

QA_PREBUILT="*"

src_prepare() {
	default

	local files=(
		lib/libbugly.so
		lib/libcurl.so
		plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so
	)

	for f in "${files[@]}"; do
		rm -fr opt/wemeet/${f} || die
	done
}

src_install() {
	insinto /usr/share
	doins -r opt/wemeet/icons

	doicon opt/wemeet/wemeet.svg

	insinto /opt/wemeet
	local dirs=(
		bin
		lib
		plugins
		resources
		translations
	)

	for d in "${dirs[@]}"; do
		doins -r opt/wemeet/${d}
	done

	exeinto /opt/wemeet
	doexe "${FILESDIR}"/wemeetapp.sh

	fperms -R +x /opt/wemeet/lib

	for f in wemeetapp QtWebEngineProcess; do
		fperms +x /opt/wemeet/bin/${f}
	done

	sed 's|^Icon=.*|Icon=wemeet|' \
		-i usr/share/applications/wemeetapp.desktop || die

	domenu usr/share/applications/wemeetapp.desktop
}
