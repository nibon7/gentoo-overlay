# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anyhow@1.0.81
	arrayvec@0.7.4
	async-channel@2.2.0
	atomic_refcell@0.1.13
	autocfg@1.1.0
	bitflags@2.5.0
	block@0.1.6
	bumpalo@3.15.4
	cairo-rs@0.19.2
	cairo-sys-rs@0.19.2
	cc@1.0.90
	cfg-expr@0.15.7
	cfg-if@1.0.0
	chrono@0.4.35
	color_quant@1.1.0
	concurrent-queue@2.4.0
	core-foundation-sys@0.8.6
	crossbeam-utils@0.8.19
	deluxe-core@0.5.0
	deluxe-macros@0.5.0
	deluxe@0.5.0
	either@1.10.0
	equivalent@1.0.1
	event-listener-strategy@0.5.0
	event-listener@5.2.0
	field-offset@0.3.6
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	gdk-pixbuf-sys@0.19.0
	gdk-pixbuf@0.19.2
	gdk4-sys@0.8.1
	gdk4-wayland-sys@0.8.1
	gdk4-wayland@0.8.1
	gdk4-win32-sys@0.8.1
	gdk4-win32@0.8.1
	gdk4-x11-sys@0.8.1
	gdk4-x11@0.8.1
	gdk4@0.8.1
	gettext-rs@0.7.0
	gettext-sys@0.21.3
	gif@0.13.1
	gio-sys@0.19.0
	gio@0.19.3
	glib-macros@0.19.3
	glib-sys@0.19.0
	glib@0.19.3
	gobject-sys@0.19.0
	graphene-rs@0.19.2
	graphene-sys@0.19.0
	gsettings-macro@0.2.0
	gsk4-sys@0.8.1
	gsk4@0.8.1
	gst-plugin-gif@0.12.0
	gst-plugin-gtk4@0.12.1
	gst-plugin-version-helper@0.8.1
	gstreamer-base-sys@0.22.0
	gstreamer-base@0.22.0
	gstreamer-gl-egl-sys@0.22.0
	gstreamer-gl-egl@0.22.0
	gstreamer-gl-sys@0.22.0
	gstreamer-gl-wayland-sys@0.22.0
	gstreamer-gl-wayland@0.22.0
	gstreamer-gl-x11-sys@0.22.0
	gstreamer-gl-x11@0.22.0
	gstreamer-gl@0.22.0
	gstreamer-sys@0.22.2
	gstreamer-video-sys@0.22.1
	gstreamer-video@0.22.1
	gstreamer@0.22.3
	gtk4-macros@0.8.1
	gtk4-sys@0.8.1
	gtk4@0.8.1
	hashbrown@0.14.3
	heck@0.4.1
	heck@0.5.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	if_chain@1.0.2
	indexmap@2.2.5
	itertools@0.12.1
	itoa@1.0.10
	js-sys@0.3.69
	lazy_static@1.4.0
	libadwaita-sys@0.6.0
	libadwaita@0.6.0
	libc@0.2.153
	locale_config@0.3.0
	log@0.4.21
	malloc_buf@0.0.6
	memchr@2.7.1
	memoffset@0.9.0
	muldiv@1.0.1
	nu-ansi-term@0.46.0
	num-integer@0.1.46
	num-rational@0.4.1
	num-traits@0.2.18
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	once_cell@1.19.0
	option-operations@0.5.0
	overload@0.1.1
	pango-sys@0.19.0
	pango@0.19.3
	parking@2.2.0
	paste@1.0.14
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.30
	proc-macro-crate@1.3.1
	proc-macro-crate@3.1.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.79
	quick-xml@0.31.0
	quote@1.0.35
	regex-automata@0.4.6
	regex-syntax@0.8.2
	regex@1.10.3
	rustc_version@0.4.0
	ryu@1.0.17
	semver@1.0.22
	serde@1.0.197
	serde_derive@1.0.197
	serde_spanned@0.6.5
	serde_yaml@0.9.33
	sharded-slab@0.1.7
	slab@0.4.9
	smallvec@1.13.1
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.53
	system-deps@6.2.2
	target-lexicon@0.12.14
	temp-dir@0.1.12
	thiserror-impl@1.0.58
	thiserror@1.0.58
	thread_local@1.1.8
	toml@0.8.12
	toml_datetime@0.6.5
	toml_edit@0.19.15
	toml_edit@0.21.1
	toml_edit@0.22.8
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.2.0
	tracing-subscriber@0.3.18
	tracing@0.1.40
	unicode-ident@1.0.12
	unsafe-libyaml@0.2.11
	valuable@0.1.0
	version-compare@0.2.0
	version_check@0.9.4
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	weezl@0.1.8
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.52.0
	windows-targets@0.52.4
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.52.4
	windows_x86_64_gnu@0.52.4
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_msvc@0.52.4
	winnow@0.5.40
	winnow@0.6.5
"

inherit cargo gnome2-utils meson optfeature xdg

DESCRIPTION="A simple screen recorder with a minimal interface"
HOMEPAGE="https://github.com/SeaDve/Kooha"

SRC_URI="https://github.com/SeaDve/Kooha/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}"/${P^}
LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT MPL-2.0
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~mips ~riscv ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.79:2
	>=gui-libs/gtk-4.14:4
	>=gui-libs/libadwaita-1.5
	>=media-libs/gstreamer-1.22
	>=media-libs/gst-plugins-base-1.22
	>=media-libs/gst-plugins-bad-1.22
	>=media-plugins/gst-plugins-opus-1.22
	>=media-plugins/gst-plugins-lame-1.22
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
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

PATCHES=( "${FILESDIR}"/kooha-glib-2.79.patch )

src_prepare() {
	default
	xdg_environment_reset

	sed "s/'CARGO_HOME='.*/]/" -i src/meson.build || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	optfeature_header "Optional programs for extra features:"
	optfeature "hardware acceleration support" ">=media-plugins/gst-plugins-vaapi-1.22"
	optfeature "MP4 support" "media-libs/x264 >=media-libs/gst-plugins-ugly-1.22"
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
