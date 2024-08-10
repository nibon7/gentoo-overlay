# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson

DESCRIPTION="Glycin loaders for several formats"
HOMEPAGE="https://gitlab.gnome.org/sophie-h/glycin"

LICENSE="MPL-2.0 LGPL-2+"
SLOT="1"
KEYWORDS="~amd64 ~arm64 ~loong ~mips ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="heif jpegxl svg test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.60
	>=gui-libs/gtk-4.12.0:4
	>=media-libs/lcms-2.14
	>=sys-libs/libseccomp-2.5.0
	heif? ( >=media-libs/libheif-1.17.0 )
	jpegxl? (
		>=media-libs/libjxl-0.8.2
		<=media-libs/libjxl-0.11.0
	)
	svg? (
		gnome-base/librsvg:2
		>=x11-libs/cairo-1.17.0
	)
	sys-apps/bubblewrap
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	>=virtual/rust-1.75
"

QA_FLAGS_IGNORED="usr/libexec/${PN}/${SLOT}\+/glycin-.*"

src_prepare() {
	default

	sed "s#\('CARGO_HOME'\): .*#\1: meson.project_source_root() / '.cargo',#" -i loaders/meson.build || die
}

src_configure() {
	local loaders="glycin-image-rs"
	use heif && loaders+=",glycin-heif"
	use jpegxl && loaders+=",glycin-jxl"
	use svg && loaders+=",glycin-svg"

	local emesonargs=(
		-Dprofile=release
		-Dloaders="${loaders}"
		$(meson_use test tests)
	)
	meson_src_configure
}
