# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN/-loaders/}

GNOME_ORG_MODULE="${MY_PN}"

inherit gnome.org meson

DESCRIPTION="Glycin loaders for several formats"
HOMEPAGE="https://gitlab.gnome.org/sophie-h/glycin"

LICENSE="MPL-2.0 LGPL-2+"
SLOT="1"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~amd64-linux ~x86-linux"
IUSE="heif jpegxl svg test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_PN}-${PV}"

DEPEND="
	>=dev-libs/glib-2.60
	>=gui-libs/gtk-4.12.0:4
	>=media-libs/lcms-2.14
	>=sys-libs/libseccomp-2.5.0
	heif? ( >=media-libs/libheif-1.17.0 )
	jpegxl? (
		>=media-libs/libjxl-0.10.0
	)
	svg? (
		>=gnome-base/librsvg-2.52.0
		>=x11-libs/cairo-1.17.0
	)
	sys-apps/bubblewrap
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	>=virtual/rust-1.77
"

QA_FLAGS_IGNORED="usr/libexec/${PN}/${SLOT}\+/glycin-.*"

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
		-Dglycin-loaders=true
		-Dloaders="${loaders// /,}"
		-Dintrospection=false
		-Dlibglycin=false
		-Dvapi=false
		$(meson_use test tests)
	)
	meson_src_configure
}
