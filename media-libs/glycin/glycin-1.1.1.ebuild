# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala

DESCRIPTION="Sandboxed image decoding"
HOMEPAGE="https://gitlab.gnome.org/sophie-h/glycin"

LICENSE="MPL-2.0 LGPL-2+"
SLOT="1"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~amd64-linux ~x86-linux"
IUSE="bindings doc heif introspection jpegxl +loaders svg vala test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	|| ( loaders bindings )
	doc? ( introspection )
	heif? ( loaders )
	jpegxl? ( loaders )
	svg? ( loaders )
	vala? ( introspection )
"

DEPEND="
	>=dev-libs/glib-2.60
	>=gui-libs/gtk-4.12.0:4
	>=media-libs/lcms-2.14
	>=sys-libs/libseccomp-2.5.0
	sys-apps/bubblewrap
	heif? ( >=media-libs/libheif-1.17.0 )
	introspection? ( dev-libs/gobject-introspection )
	jpegxl? ( >=media-libs/libjxl-0.10.0 )
	svg? (
		>=gnome-base/librsvg-2.52.0
		>=x11-libs/cairo-1.17.0
	)
"
RDEPEND="
	${DEPEND}
	!media-libs/glycin-loaders
"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
"

pkg_setup() {
	use loaders && QA_FLAGS_IGNORED="usr/libexec/glycin-loaders/${SLOT}\+/glycin-.*"
}

src_prepare() {
	default

	sed "s#\(cargo_home\) = .*#\1 = meson.project_source_root() / '.cargo'#" -i meson.build || die
}

src_configure() {
	local loaders=(
		glycin-image-rs
		$(usev heif glycin-heif)
		$(usev jpegxl glycin-jxl)
		$(usev svg glycin-svg)
	)

	loaders=${loaders[*]}

	local emesonargs=(
		-Dprofile=release
		-Dloaders="${loaders// /,}"
		$(meson_use bindings libglycin)
		$(meson_use introspection)
		$(meson_use loaders glycin-loaders)
		$(meson_use vala vapi)
		$(meson_use doc capi_docs)
		$(meson_use test tests)
	)
	meson_src_configure
}
