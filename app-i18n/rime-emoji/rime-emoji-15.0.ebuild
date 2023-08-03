# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Emoji support for rime"
HOMEPAGE="https://github.com/rime/rime-emoji"
SRC_URI="https://github.com/rime/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ppc ppc64 ~riscv x86"

DEPEND="app-i18n/rime-data
	app-i18n/opencc
"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/rime-data
	doins -r emoji_suggestion.yaml opencc
}
