# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Microsoft Windows 11 Simplified Chinese TrueType fonts"
HOMEPAGE="https://www.microsoft.com/typography/fonts/product.aspx?PID=164"
SRC_URI="
	l10n_ja? ( ${PN}-ja-${PV}.zip )
	l10n_ko? ( ${PN}-ko-${PV}.zip )
	l10n_zh-CN? ( ${PN}-zh_cn-${PV}.zip )
	l10n_zh-TW? ( ${PN}-zh_tw-${PV}.zip )
"

LICENSE="microsoft"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="l10n_ja l10n_ko +l10n_zh-CN l10n_zh-TW"
REQUIRED_USE="|| ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW )"
RESTRICT="binchecks strip fetch"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_SUFFIX="ttf ttc"
FONT_CONF=( "${PN}-zh_cn-${PV}/66-${PN}.conf" )

pkg_nofetch() {
	einfo "Please note that usage of Microsoft fonts outside running Windows"
	einfo "system is prohibited by EULA (although in certain countries EULA is invalid)."
	einfo "Please consult Microsoft license before using fonts."
	einfo "You can acquire fonts either from an installed and up-to-date Windows 11"
	einfo "system or the most recent install medium."
}

src_prepare() {
	default
	cp "${FILESDIR}/66-${PN}.conf" "${S}/${PN}-zh_cn-${PV}" || die
}

src_install() {
	use l10n_ja && FONT_S="${S}/${PN}-ja-${PV}" font_src_install
	use l10n_ko && FONT_S="${S}/${PN}-ko-${PV}" font_src_install
	use l10n_zh-CN && FONT_S="${S}/${PN}-zh_cn-${PV}" font_src_install
	use l10n_zh-TW && FONT_S="${S}/${PN}-zh_tw-${PV}" font_src_install
}
