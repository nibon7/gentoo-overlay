# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

COMMIT="ab226c63380c4233e2f490ba17e6ea8f393999e2"
STB_COMMIT="5c205738c191bcb0abc65c4febfa9bd25ff35234"

DESCRIPTION="Hook library that enables screenshare with Tencent Wemeet on Linux Wayland"
HOMEPAGE="https://github.com/xuwd1/wemeet-wayland-screenshare"
SRC_URI="
	https://github.com/xuwd1/wemeet-wayland-screenshare/archive/${COMMIT}.tar.gz -> ${PN}-g${COMMIT:0:7}.tar.gz
	https://github.com/nothings/stb/archive/${STB_COMMIT}.tar.gz -> stb-g${STB_COMMIT:0:7}.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64 ~loong"

DEPEND="
	dev-libs/glib:2
	dev-libs/libportal
	media-libs/opencv
	media-video/pipewire
	x11-libs/libXrandr
	x11-libs/libX11
"

RDEPEND="
	${DEPEND}
	sys-apps/xdg-desktop-portal
	|| (
		gui-libs/xdg-desktop-portal-lxqt
		gui-libs/xdg-desktop-portal-wlr
		kde-plasma/xdg-desktop-portal-kde
		sys-apps/xdg-desktop-portal-gnome
		sys-apps/xdg-desktop-portal-gtk
		sys-apps/xdg-desktop-portal-xapp
	)
	media-video/wireplumber
	>=net-im/wemeet-bin-3.19.2.400
"

src_unpack() {
	default

	rm -fr stb || die
	ln -sf "${WORKDIR}"/stb-${STB_COMMIT} stb || die
}

src_install() {
	exeinto /opt/wemeet/lib
	doexe "${BUILD_DIR}"/libhook.so
	domenu "${FILESDIR}"/wemeetapp-wayland-screenshare.desktop
}
