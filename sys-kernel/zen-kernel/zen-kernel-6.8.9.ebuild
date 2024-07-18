# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_GENERIC_UKI=0
KERNEL_IUSE_MODULES_SIGN=0

inherit kernel-build unpacker

MY_P=linux-${PV%.*}
GENPATCHES_VER="12"
GENPATCHES_P=genpatches-${PV%.*}-${GENPATCHES_VER}

DESCRIPTION="Zen Kernel built with Gentoo patches"
HOMEPAGE="
	https://wiki.gentoo.org/wiki/Project:Distribution_Kernel
	https://github.com/zen-kernel
"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/zen-kernel/zen-kernel/releases/download/v${PV}-zen1/linux-v${PV}-zen1.patch.zst
"
S=${WORKDIR}/${MY_P}

KEYWORDS="~amd64"
IUSE="debug +savedconfig"
REQUIRED_USE="savedconfig"

BDEPEND="
	debug? ( dev-util/pahole )
"
PDEPEND="
	>=virtual/dist-kernel-${PV}
"

QA_FLAGS_IGNORED="
	usr/src/linux-.*/scripts/gcc-plugins/.*.so
	usr/src/linux-.*/vmlinux
"

src_unpack() {
	unpacker "linux-v${PV}-zen1.patch.zst"
	default
}

src_prepare() {
	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)
	default
}
