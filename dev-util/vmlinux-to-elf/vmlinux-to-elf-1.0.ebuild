# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A tool to recover a fully analyzable .ELF from a raw kernel"
HOMEPAGE="https://github.com/marin-m/vmlinux-to-elf"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/marin-m/vmlinux-to-elf.git"
	inherit git-r3
else
	COMMIT="fa5c9305ae1c4bbcd2debabb810e7613def690a7"
	SRC_URI="https://github.com/marin-m/vmlinux-to-elf/archive/${COMMIT}.tar.gz -> ${P}-g${COMMIT:0:7}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="amd64 arm64 ~loong ~riscv x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-python/lz4-4.3.3[${PYTHON_USEDEP}]
	>=dev-python/zstandard-0.22.0[${PYTHON_USEDEP}]
"
