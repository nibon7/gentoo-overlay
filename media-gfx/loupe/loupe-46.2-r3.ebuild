# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Image viewer for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/loupe"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0
	CC0-1.0 LGPL-2.1+ MIT MIT-0 MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~amd64-linux ~x86-linux"
IUSE="X test"
RESTRICT="!test? ( test )"

DEPEND="
	>=gui-libs/gtk-4.13.6:4[X?]
	>=gui-libs/libadwaita-1.4.0
	>=dev-libs/libgweather-4.0.0
	>=media-libs/lcms-2.12.0
	>=sys-libs/libseccomp-2.5.0
	>=x11-libs/cairo-1.14.0
	media-gfx/glycin-loaders
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/appstream
	virtual/pkgconfig
	>=virtual/rust-1.75
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default
	xdg_environment_reset

	sed "s#\('CARGO_HOME'\): .*#\1: source_root / '.cargo'}#" -i src/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dprofile=release
		-Ddisable-glycin-sandbox=false
		$(meson_feature X x11)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
