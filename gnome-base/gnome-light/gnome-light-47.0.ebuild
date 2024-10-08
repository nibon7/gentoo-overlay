# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

P_RELEASE="$(ver_cut 1).0"

DESCRIPTION="Meta package for GNOME-Light, merge this package to install"
HOMEPAGE="https://www.gnome.org/"
S="${WORKDIR}"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="cups +gnome-shell"

# XXX: Note to developers:
# This is a wrapper for the 'light' GNOME 3 desktop, and should only consist of
# the bare minimum of libs/apps needed. It is basically gnome-base/gnome without
# any apps, but shouldn't be used by users unless they know what they are doing.
# cantarell minimum version is ensured here as gnome-shell depends on it.
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-47.0
	>=gnome-base/gnome-settings-daemon-47[cups?]
	>=gnome-base/gnome-control-center-47.0.1[cups?]

	>=gnome-base/nautilus-47.0

	gnome-shell? (
		>=x11-wm/mutter-47.0
		>=dev-libs/gjs-1.80.2
		>=gnome-base/gnome-shell-47.0
		|| (
			>=media-fonts/cantarell-0.303.1
			>=media-fonts/dejavu-2.37
			>=media-fonts/inter-4.0
			>=media-fonts/noto-20240531
		)
	)

	>=x11-themes/adwaita-icon-theme-${P_RELEASE}
	>=x11-themes/gnome-backgrounds-${P_RELEASE}

	|| (
		>=x11-terms/gnome-terminal-3.50.1
		>=gui-apps/gnome-console-47.0
		>=x11-terms/alacritty-0.12.3
	)
"
DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.52.1"
BDEPEND=""

pkg_pretend() {
	if ! use gnome-shell; then
		# Users probably want to use gnome-flashback, e16, sawfish, etc
		ewarn "You're not installing GNOME Shell"
		ewarn "You will have to install and manage a window manager by yourself"
	fi
}

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
