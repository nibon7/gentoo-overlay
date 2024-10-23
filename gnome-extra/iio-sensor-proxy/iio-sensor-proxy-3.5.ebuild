# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg

DESCRIPTION="Proxies sensor devices (accelerometers, light sensors, compass) to applications through D-Bus"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy"
SRC_URI="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv x86"

DEPEND="
	dev-libs/libgudev
	dev-libs/glib:2
	sys-apps/systemd
	sys-auth/polkit
"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
