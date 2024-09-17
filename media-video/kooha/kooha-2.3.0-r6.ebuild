# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson optfeature xdg

DESCRIPTION="A simple screen recorder with a minimal interface"
HOMEPAGE="https://github.com/SeaDve/Kooha"

SRC_URI="https://github.com/SeaDve/Kooha/releases/download/v${PV}/${P}.tar.xz"
LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT MPL-2.0
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.80:2
	>=gui-libs/gtk-4.14:4[X,wayland]
	>=gui-libs/libadwaita-1.5
	>=media-libs/gstreamer-1.22
	|| (
		>=media-libs/gst-plugins-base-1.22[X,gles2,wayland]
		>=media-libs/gst-plugins-base-1.22[X,opengl,wayland]
	)
	media-video/pipewire[gstreamer]
	sys-apps/xdg-desktop-portal
	|| (
		gui-libs/xdg-desktop-portal-lxqt
		gui-libs/xdg-desktop-portal-wlr
		kde-plasma/xdg-desktop-portal-kde
		sys-apps/xdg-desktop-portal-gnome
		sys-apps/xdg-desktop-portal-gtk
		sys-apps/xdg-desktop-portal-xapp
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/appstream
	dev-util/desktop-file-utils
	sys-devel/gettext
	virtual/pkgconfig
	>=virtual/rust-1.73.0
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

PATCHES=( "${FILESDIR}"/kooha-glib-2.79.patch )

src_prepare() {
	default
	xdg_environment_reset

	sed "s#\('CARGO_HOME='\) + .*#\1 + meson.project_source_root() / '.cargo' ]#" -i src/meson.build || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	optfeature_header "Optional programs for extra features:"
	optfeature "Matroska support" ">=media-plugins/gst-plugins-opus-1.22 >=media-plugins/gst-plugins-x264-1.22"
	optfeature "MP4 support" ">=media-plugins/gst-plugins-lame-1.22 >=media-plugins/gst-plugins-x264-1.22"
	optfeature "WebM support" ">=media-plugins/gst-plugins-opus-1.22 >=media-plugins/gst-plugins-vpx-1.22"
	optfeature "VA-API support" ">=media-plugins/gst-plugins-opus-1.22 >=media-plugins/gst-plugins-vaapi-1.22"
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
