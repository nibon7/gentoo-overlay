# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_GENERIC_UKI=1
KERNEL_IUSE_MODULES_SIGN=1

inherit kernel-build unpacker

MY_P=linux-${PV%.*}
ZEN_VER=${PV%.0}

DESCRIPTION="Zen patched kernel"
HOMEPAGE="
	https://wiki.gentoo.org/wiki/Project:Distribution_Kernel
	https://www.kernel.org
	https://github.com/zen-kernel
"
SRC_URI="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://github.com/zen-kernel/zen-kernel/releases/download/v${ZEN_VER}-zen1/linux-v${ZEN_VER}-zen1.patch.zst
"

if ver_test "$(ver_cut 3)" -gt 0; then
	SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/patch-${PV}.xz"
fi

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

src_prepare() {
	local PATCHES=()
	if ver_test "$(ver_cut 3)" -gt 0; then
		PATCHES+=( "${WORKDIR}"/patch-${PV} )
	fi

	PATCHES+=( "${WORKDIR}"/linux-v${ZEN_VER}-zen1.patch )

	default
}
