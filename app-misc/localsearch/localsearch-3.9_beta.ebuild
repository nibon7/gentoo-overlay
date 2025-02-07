# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

inherit flag-o-matic gnome.org gnome2-utils meson python-any-r1 systemd xdg

DESCRIPTION="An efficient search engine for desktop, embedded and mobile"
HOMEPAGE="https://gitlab.gnome.org/GNOME/localsearch"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~riscv ~x86"

IUSE="cue exif +ffmpeg gif gsf iptc +iso +jpeg networkmanager +pdf +playlist raw +rss seccomp test +tiff upower +xml xmp xps"

RESTRICT="!test? ( test )"

# tracker-2.1.7 currently always depends on ICU (theoretically could be libunistring instead);
# so choose ICU over enca always here for the time being (ICU is preferred)
RDEPEND="
	!<app-misc/tracker-miners-3.8.0
	>=dev-libs/glib-2.70:2
	dev-libs/libgudev
	>=app-misc/tinysparql-3.8.0:3

	>=sys-apps/dbus-1.3.1
	xmp? ( >=media-libs/exempi-2.1.0:= )
	raw? ( media-libs/gexiv2 )
	cue? ( >=media-libs/libcue-2.0.0:= )
	exif? ( >=media-libs/libexif-0.6 )
	gsf? ( >=gnome-extra/libgsf-1.14.24:= )
	xps? ( app-text/libgxps )
	iptc? ( media-libs/libiptcdata )
	jpeg? ( media-libs/libjpeg-turbo:0= )
	iso? ( >=sys-libs/libosinfo-1.10.0-r1 )
	>=media-libs/libpng-1.2:0=
	seccomp? ( >=sys-libs/libseccomp-2.0 )
	tiff? ( media-libs/tiff:= )
	xml? ( >=dev-libs/libxml2-2.6 )
	pdf? ( >=app-text/poppler-0.16.0:=[cairo] )
	playlist? ( >=dev-libs/totem-pl-parser-3:= )
	sys-apps/util-linux

	gif? ( media-libs/giflib:= )

	networkmanager? ( net-misc/networkmanager )

	rss? ( >=net-libs/libgrss-0.7:0 )
	app-arch/gzip

	upower? ( >=sys-power/upower-0.9.0:= )

	>=dev-libs/icu-4.8.1.1:=

	ffmpeg? ( media-video/ffmpeg:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	dev-libs/libxslt
	dev-util/glib-utils
	dev-util/gdbus-codegen

	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pygobject[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/tap-py[${PYTHON_USEDEP}]')
	)
"

python_check_deps() {
	python_has_version -b \
		"dev-python/pygobject[${PYTHON_USEDEP}]" \
		"dev-python/tap-py[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	gnome2_environment_reset
}

src_configure() {
	append-cflags -DTRACKER_DEBUG -DG_DISABLE_CAST_CHECKS

	local emesonargs=(
		-Dman=true
		-Dextract=true
		$(meson_use test functional_tests)
		$(meson_use test tests_tap_protocol)
		-Dminer_fs=true
		$(meson_use rss miner_rss)
		-Dwriteback=true
		-Dabiword=true
		-Dicon=true
		-Dmp3=true
		-Dps=true
		-Dtext=true
		-Dunzip_ps_gz_files=true # spawns gunzip

		$(meson_feature networkmanager network_manager)
		$(meson_feature cue)
		$(meson_feature exif)
		$(meson_feature gif)
		$(meson_feature gsf)
		$(meson_feature iptc)
		$(meson_feature iso)
		$(meson_feature jpeg)
		$(meson_feature pdf)
		$(meson_feature playlist)
		-Dlandlock=disabled
		-Dpng=enabled
		$(meson_feature raw)
		$(meson_feature tiff)
		$(meson_feature xml)
		$(meson_feature xmp)
		$(meson_feature xps)

		-Dbattery_detection=$(usex upower upower none)
		# enca is a possibility, but right now we have tracker core always dep on icu and icu is preferred over enca
		-Dcharset_detection=icu
		$(meson_feature ffmpeg libav)
		# gupnp gstreamer_backend is in bad state, upstream suggests to use discoverer, which is the default
		-Dsystemd_user_services_dir="$(systemd_get_userunitdir)"
	)
	meson_src_configure
}

src_test() {
	export GSETTINGS_BACKEND="dconf" # Tests require dconf and explicitly check for it (env_reset set it to "memory")
	export PYTHONPATH="${EROOT}"/usr/$(get_libdir)/tracker-3.0
	dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
