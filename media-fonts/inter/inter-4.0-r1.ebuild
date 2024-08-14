# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MY_PN=${PN^}

DESCRIPTION="A typeface carefully crafted & designed for computer screens"
HOMEPAGE="https://github.com/rsms/inter"
SRC_URI="https://github.com/rsms/inter/releases/download/v${PV}/${MY_PN}-${PV}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttc ttf"
