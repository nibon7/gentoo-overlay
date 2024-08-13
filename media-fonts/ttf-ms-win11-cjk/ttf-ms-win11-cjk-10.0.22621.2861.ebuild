# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Microsoft Windows 11 CJK TrueType fonts"
HOMEPAGE="https://www.microsoft.com/typography/fonts/product.aspx?PID=164"
SRC_URI="
	l10n_ja? ( msyhbd.ttc msyhl.ttc msyh.ttc simsunb.ttf simsun.ttc )
	l10n_ko? ( msgothic.ttc YuGothB.ttc YuGothL.ttc YuGothM.ttc YuGothR.ttc )
	l10n_zh-CN? ( msyhbd.ttc msyhl.ttc msyh.ttc simsunb.ttf simsun.ttc )
	l10n_zh-TW? ( mingliub.ttc msjhbd.ttc msjhl.ttc msjh.ttc )
"

LICENSE="microsoft"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="l10n_ja l10n_ko +l10n_zh-CN l10n_zh-TW"
REQUIRED_USE="|| ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW )"
RESTRICT="binchecks strip fetch"

S="${DISTDIR}"
FONT_SUFFIX="ttc"
FONT_CONF=( "${FILESDIR}"/66-${PN}.conf )

pkg_nofetch() {
	einfo "Please note that usage of Microsoft fonts outside running Windows"
	einfo "system is prohibited by EULA (although in certain countries EULA is invalid)."
	einfo "Please consult Microsoft license before using fonts."
	einfo "You can acquire fonts either from an installed and up-to-date Windows 11"
	einfo "system or the most recent install medium."
}

src_install() {
	if use l10n_ja || use l10n_zh-CN; then
		FONT_SUFFIX+=" ttf"
	fi

	font_src_install
}
