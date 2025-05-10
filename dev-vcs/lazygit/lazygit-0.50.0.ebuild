# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Simple terminal UI for git commands"
HOMEPAGE="https://github.com/jesseduffield/lazygit"
SRC_URI="https://github.com/jesseduffield/lazygit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~riscv x86"

DEPEND=">=dev-vcs/git-2.22"

src_install() {
	dobin ${PN}

	DOCS=(
		docs/.
	)
	einstalldocs
}
