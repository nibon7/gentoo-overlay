# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler@1.0.2
	aho-corasick@1.1.3
	anstream@0.6.15
	anstyle@1.0.8
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anyhow@1.0.86
	arc-swap@1.7.1
	ashpd@0.9.1
	async-broadcast@0.7.1
	async-channel@2.3.1
	async-executor@1.13.0
	async-fs@2.1.2
	async-io@2.3.3
	async-lock@3.4.0
	async-net@2.0.0
	async-process@2.2.3
	async-recursion@1.1.1
	async-signal@0.2.9
	async-task@4.7.1
	async-trait@0.1.81
	atomic-waker@1.1.2
	autocfg@1.3.0
	bitflags@1.3.2
	bitflags@2.6.0
	block@0.1.6
	block-buffer@0.10.4
	blocking@1.6.1
	bytemuck@1.16.3
	byteorder@1.5.0
	cairo-rs@0.20.0
	cairo-sys-rs@0.20.0
	cc@1.1.7
	cfg-expr@0.15.8
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	colorchoice@1.0.2
	concurrent-queue@2.5.0
	cpufeatures@0.2.12
	crc32fast@1.4.2
	crossbeam-utils@0.8.20
	crypto-common@0.1.6
	digest@0.10.7
	dlib@0.5.2
	dunce@1.0.4
	endi@1.1.0
	enumflags2@0.7.10
	enumflags2_derive@0.7.10
	env_filter@0.1.2
	env_logger@0.11.5
	equivalent@1.0.1
	errno@0.3.9
	event-listener@5.3.1
	event-listener-strategy@0.5.2
	fastrand@2.1.0
	field-offset@0.3.6
	flate2@1.0.30
	foreign-types@0.5.0
	foreign-types-macros@0.2.3
	foreign-types-shared@0.3.1
	form_urlencoded@1.2.1
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-lite@2.3.0
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-timer@3.0.3
	futures-util@0.3.30
	gdk-pixbuf@0.20.0
	gdk-pixbuf-sys@0.20.0
	gdk4@0.9.0
	gdk4-sys@0.9.0
	gdk4-wayland@0.9.0
	gdk4-wayland-sys@0.9.0
	gdk4-x11@0.9.0
	gdk4-x11-sys@0.9.0
	generic-array@0.14.7
	getrandom@0.2.15
	gettext-rs@0.7.0
	gettext-sys@0.21.3
	gio@0.20.0
	gio-sys@0.20.0
	glib@0.20.0
	glib-macros@0.20.0
	glib-sys@0.20.0
	glycin@2.0.0-beta
	glycin-utils@2.0.0-beta
	gobject-sys@0.20.0
	graphene-rs@0.20.0
	graphene-sys@0.20.0
	gsk4@0.9.0
	gsk4-sys@0.9.0
	gtk4@0.9.0
	gtk4-macros@0.9.0
	gtk4-sys@0.9.0
	gufo-common@0.1.0
	gufo-exif@0.1.1
	gvdb@0.7.0
	gvdb-macros@0.1.13
	gweather-sys@4.5.0
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.4.0
	hex@0.4.3
	humantime@2.1.0
	idna@0.5.0
	indexmap@2.3.0
	is_terminal_polyfill@1.70.1
	itoa@1.0.11
	jobserver@0.1.32
	kamadak-exif@0.5.5
	lazy_static@1.5.0
	lcms2@6.1.0
	lcms2-sys@4.0.5
	libadwaita@0.7.0
	libadwaita-sys@0.7.0
	libc@0.2.155
	libgweather@4.5.0
	libloading@0.8.5
	libseccomp@0.3.0
	libseccomp-sys@0.2.1
	linux-raw-sys@0.4.14
	litrs@0.4.1
	locale_config@0.3.0
	log@0.4.22
	malloc_buf@0.0.6
	matchers@0.1.0
	memchr@2.7.4
	memfd@0.6.4
	memmap2@0.9.4
	memoffset@0.9.1
	miniz_oxide@0.7.4
	mutate_once@0.1.1
	nix@0.29.0
	nu-ansi-term@0.46.0
	num-traits@0.2.19
	objc@0.2.7
	objc-foundation@0.1.1
	objc_id@0.1.1
	once_cell@1.19.0
	ordered-stream@0.2.0
	overload@0.1.1
	pango@0.20.0
	pango-sys@0.20.0
	parking@2.2.0
	paste@1.0.15
	percent-encoding@2.3.1
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	piper@0.2.3
	pkg-config@0.3.30
	polling@3.7.2
	ppv-lite86@0.2.18
	proc-macro-crate@3.1.0
	proc-macro2@1.0.86
	quick-xml@0.36.1
	quote@1.0.36
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	regex@1.10.6
	regex-automata@0.1.10
	regex-automata@0.4.7
	regex-syntax@0.6.29
	regex-syntax@0.8.4
	rmp@0.8.14
	rmp-serde@1.3.0
	rustc_version@0.4.0
	rustix@0.38.34
	rustversion@1.0.17
	ryu@1.0.18
	same-file@1.0.6
	semver@1.0.23
	serde@1.0.204
	serde_derive@1.0.204
	serde_json@1.0.122
	serde_repr@0.1.19
	serde_spanned@0.6.7
	sha1@0.10.6
	sharded-slab@0.1.7
	signal-hook-registry@1.4.2
	slab@0.4.9
	smallvec@1.13.2
	static_assertions@1.1.0
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.72
	system-deps@7.0.1
	target-lexicon@0.12.16
	temp-dir@0.1.13
	tempfile@3.10.1
	thiserror@1.0.63
	thiserror-impl@1.0.63
	thread_local@1.1.8
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	toml@0.8.19
	toml_datetime@0.6.8
	toml_edit@0.21.1
	toml_edit@0.22.20
	tracing@0.1.40
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.2.0
	tracing-subscriber@0.3.18
	typenum@1.17.0
	uds_windows@1.1.0
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	url@2.5.2
	utf8parse@0.2.2
	valuable@0.1.0
	version-compare@0.2.0
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.52.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.5.40
	winnow@0.6.18
	xdg-home@1.2.0
	yeslogic-fontconfig-sys@6.0.0
	zbus@4.4.0
	zbus_macros@4.4.0
	zbus_names@3.0.0
	zerocopy@0.6.6
	zerocopy@0.7.35
	zerocopy-derive@0.6.6
	zerocopy-derive@0.7.35
	zvariant@4.2.0
	zvariant_derive@4.2.0
	zvariant_utils@2.1.0
"

inherit cargo gnome.org gnome2-utils meson xdg

DESCRIPTION="Image viewer for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/loupe"

SRC_URI+=" ${CARGO_CRATE_URIS}"
LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0
	CC0-1.0 ISC LGPL-2.1+ MIT MIT-0 MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~mips ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="${IUSE} X"

DEPEND="
	>=gui-libs/gtk-4.15.3:4[X?]
	>=gui-libs/libadwaita-1.6_alpha
	>=dev-libs/libgweather-4.0.0
	>=media-libs/lcms-2.12.0
	>=sys-libs/libseccomp-2.5.0
	>=x11-libs/cairo-1.14.0
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

	rm -fr .cargo/config || die
	sed '/^meson.add_dist_script/,+8d' -i meson.build || die
	sed "s#\('CARGO_HOME'\): .*#\1: '${CARGO_HOME}'}#" -i src/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dprofile=release
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
