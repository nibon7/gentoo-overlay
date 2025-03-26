# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

inherit gnome2 meson python-any-r1 systemd udev virtualx xdg

DESCRIPTION="Proxies sensor devices to applications through D-Bus"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy"
SRC_URI="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv x86"
IUSE="gtk-doc test"

RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/libgudev-237
	dev-libs/glib:2
	sys-apps/systemd
	>=sys-auth/polkit-0.91[introspection]
"

BDEPEND="
	gtk-doc? ( dev-libs/libxslt )
	test? (
		$(python_gen_any_dep '
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
		')
		x11-libs/gtk+:3
	)
"

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
	python_has_version "dev-python/psutil[${PYTHON_USEDEP}]"
}

src_prepare() {
	default
	xdg_environment_reset
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
		$(meson_use test gtk-tests)
		-Dudevrulesdir="$(get_udevdir)"/rules.d
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
	)

	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
