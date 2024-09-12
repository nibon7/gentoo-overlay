# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

GDB_VERSION=10.2
UPSTREAM_VER=
EXTRA_VER=0

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/crash-utility/crash.git"
	SRC_URI="mirror://gnu/gdb/gdb-${GDB_VERSION}.tar.gz"
	EGIT_BRANCH="master"
	inherit git-r3
else
	[[ -n ${UPSTREAM_VER} ]] && \
		UPSTREAM_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${CATEGORY}/${PN}/${P}-patches-${UPSTREAM_VER}.tar.xz"

	[[ -n ${EXTRA_VER} ]] && \
		EXTRA_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${CATEGORY}/${PN}/${PN}-8.0.3-extra-${EXTRA_VER}.tar.xz"

	SRC_URI="https://github.com/crash-utility/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		${UPSTREAM_PATCHSET_URI} ${EXTRA_PATCHSET_URI}
		mirror://gnu/gdb/gdb-${GDB_VERSION}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Red Hat crash utility; used for analyzing kernel core dumps"
HOMEPAGE="https://crash-utility.github.io/"

LICENSE="GPL-3"
SLOT="1"
IUSE="lzo snappy valgrind zstd"
IUSE_CRASH_TARGETS="
	arm64
	loongarch64
	ppc64
	riscv64
	x86_64
"
use_crash_targets="$(printf ' crash_targets_%s' ${IUSE_CRASH_TARGETS})"
IUSE+=" ${use_crash_targets}"
REQUIRED_USE="|| ( ${use_crash_targets} )"
# there is no "make test" target, but there is a test.c so the automatic
# make rules catch it and tests fail
RESTRICT="test"

DEPEND="
	lzo? ( dev-libs/lzo )
	snappy? ( app-arch/snappy )
	valgrind? ( dev-debug/valgrind )
	zstd? ( app-arch/zstd )
"

RDEPEND="
	${DEPEND}
	!${CATEGORY}/${PN}:0
"

src_prepare() {
	default

	if [[ -n ${UPSTREAM_VER} ]]; then
		einfo "Try to apply Crash's Upstream patch set"
		eapply "${WORKDIR}"/patches-upstream
	fi

	if [[ -n ${EXTRA_VER} ]]; then
		einfo "Try to apply Crash's Extra patch set"
		eapply "${WORKDIR}"/patches-extra
	fi

	sed -i -e "s|ar -rs|\${AR} -rs|g" Makefile || die
	ln -s "${DISTDIR}"/gdb-${GDB_VERSION}.tar.gz . || die
}

src_configure() {
	# bug #858344
	filter-lto

	echo "${CFLAGS}" > CFLAGS.extra || die
	echo "${LDFLAGS}" > LDFLAGS.extra || die

	default
}

src_compile() {
	local goals
	for i in lzo snappy valgrind zstd; do
		use $i && goals+=" $i"
	done

	local target
	for target in ${IUSE_CRASH_TARGETS}; do
		if use "crash_targets_${target}"; then
			emake \
				MAKECMDGOALS="${goals}" \
				CC="$(tc-getCC)" \
				AR="$(tc-getAR)" \
				target="${target^^}"
			mv ${PN} "${PN}-${target}" || die
			rm -fr gdb-${GDB_VERSION} || die
			emake clean
		fi
	done
}

src_install() {
	local target
	for target in ${IUSE_CRASH_TARGETS}; do
		if use "crash_targets_${target}"; then
			dobin "${PN}-${target}"
		fi
	done
}
