# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps flag-o-matic systemd toolchain-funcs
DESCRIPTION="A Tunnel which Turns UDP Traffic into Encrypted UDP/FakeTCP/ICMP Traffic"
HOMEPAGE="https://github.com/wangyu-/udp2raw"
SRC_URI="https://github.com/wangyu-/udp2raw/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="cpu_flags_x86_aes"

RDEPEND="net-firewall/iptables"
BDEPEND="net-libs/libpcap"

FILECAPS=(
	-m 0755 "cap_net_raw+ep cap_net_admin+ep" "usr/bin/${PN}"
)

src_prepare() {
	# Disable optimisation flags and remove prefixes of exec files
	sed -e 's/ -O[0-3a-z]*//' \
		-e 's/\${NAME}_[a-zA-Z0-9\$@]*/\${NAME}/' \
		-e 's/ -static//' \
		-e "s/\${cc_[a-zA-Z0-9_]*}/$(tc-getCXX)/" \
		-i makefile || die

	default
}

src_compile() {
	append-cxxflags -Wa,--noexecstack
	emake OPT="${CXXFLAGS}" \
		$(use cpu_flags_x86_aes && use amd64 && echo amd64_hw_aes) \
		$(use arm && echo arm_asm_aes) \
		$(use x86 && echo x86_asm_aes)
}

src_install() {
	dobin udp2raw

	exeinto "/usr/lib/${PN}"
	doexe "${FILESDIR}/udp2raw_script.sh"

	insinto /etc/udp2raw
	doins example.conf

	systemd_newunit "${FILESDIR}/${PN}_at.service" "${PN}@.service"

	dodoc LICENSE.md
}
