# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_GENERIC_UKI=1
KERNEL_IUSE_MODULES_SIGN=1
KERNEL_IUSE_CLANG=1

inherit kernel-build unpacker

SLOT=zen1
MY_P=linux-${PV%.*}
ZEN_VER=${PV%.0}-${SLOT}

DESCRIPTION="Zen patched kernel"
HOMEPAGE="
	https://wiki.gentoo.org/wiki/Project:Distribution_Kernel
	https://www.kernel.org
	https://github.com/zen-kernel/zen-kernel
"
SRC_URI="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://github.com/zen-kernel/zen-kernel/releases/download/v${ZEN_VER}/linux-v${ZEN_VER}.patch.zst
	https://gitlab.archlinux.org/archlinux/packaging/packages/linux-zen/-/raw/${ZEN_VER/-/.}-1/config -> kernel-archlinux.config.${ZEN_VER}
"

if ver_test "$(ver_cut 3)" -gt 0; then
	SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/patch-${PV}.xz"
fi

S=${WORKDIR}/${MY_P}

KEYWORDS="~amd64"
IUSE="debug savedconfig"

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

	PATCHES+=( "${WORKDIR}"/linux-v${ZEN_VER}.patch )

	if use savedconfig; then
		> .config || die
	else
		cp "${DISTDIR}/kernel-archlinux.config.${ZEN_VER}" .config || die
		sed 's/archlinux/gentoo/g' -i .config || die
	fi

	kernel-build_merge_configs

	default
}
