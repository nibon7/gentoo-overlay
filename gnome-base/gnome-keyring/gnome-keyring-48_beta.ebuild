# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

inherit gnome2 meson python-any-r1 virtualx

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-keyring"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug pam selinux +ssh-agent systemd test"
RESTRICT="!test? ( test )"

# Replace gkd gpg-agent with pinentry[gnome-keyring] one, bug #547456
RDEPEND="
	>=app-crypt/gcr-3.27.90:0=[gtk]
	>=app-crypt/gnupg-2.0.28:=
	>=app-eselect/eselect-pinentry-0.5
	app-crypt/p11-kit
	app-misc/ca-certificates
	>=dev-libs/glib-2.80:2
	>=dev-libs/libgcrypt-1.2.2:0=
	pam? ( sys-libs/pam )
	selinux? ( sec-policy/selinux-gnome )
	ssh-agent? ( virtual/openssh )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=app-eselect/eselect-pinentry-0.5
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use debug debug-mode)
		$(meson_use pam)
		$(meson_use ssh-agent)
		$(meson_feature selinux)
		$(meson_feature systemd)
		-Dmanpage=true
	)

	meson_src_configure
}

src_test() {
	# Needs dbus-run-session to not get:
	# ERROR: test-dbus-search process failed: -6
	"${BROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/schema" || die
	GSETTINGS_SCHEMA_DIR="${S}/schema" virtx dbus-run-session emake check
}

pkg_postinst() {
	# cap_ipc_lock only needed if building --with-libcap-ng, but that breaks with glib-2.70
	# Never install as suid root, this breaks dbus activation, see bug #513870
	gnome2_pkg_postinst

	if ! [[ $(eselect pinentry show | grep "pinentry-gnome3") ]] ; then
		ewarn "Please select pinentry-gnome3 as default pinentry provider:"
		ewarn " # eselect pinentry set pinentry-gnome3"
	fi
}
