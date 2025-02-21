# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd go-module

GEOSITE_VER="20250219031756"
GEOIP_VER="202502050123"

DESCRIPTION="A platform for building proxies to bypass network restrictions."
HOMEPAGE="https://www.v2fly.org/"
SRC_URI="https://github.com/v2fly/v2ray-core/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/v2fly/geoip/releases/download/${GEOIP_VER}/geoip.dat -> geoip-${GEOIP_VER}.dat
	https://github.com/v2fly/domain-list-community/releases/download/${GEOSITE_VER}/dlc.dat -> geosite-${GEOSITE_VER}.dat
	https://github.com/nibon7/gentoo-deps/releases/download/${P}/${P}-deps.tar.xz"

S="${WORKDIR}/${PN}-core-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~riscv x86"

BDEPEND="dev-lang/go"

src_prepare() {
	sed -i 's|/usr/local/bin|/usr/bin|;s|/usr/local/etc|/etc|' release/config/systemd/system/*.service || die
	sed -i '/^User=/s/nobody/v2ray/;/^User=/aDynamicUser=true' release/config/systemd/system/*.service || die
	default
}

src_compile() {
	ego build -work -o "bin/v2ray" -trimpath -ldflags "-s -w" ./main
}

src_install() {
	dobin bin/v2ray

	insinto /etc/v2ray
	doins release/config/*.json

	insinto /usr/share/v2ray
	newins "${DISTDIR}/geoip-${GEOIP_VER}.dat" geoip.dat
	newins "${DISTDIR}/geosite-${GEOSITE_VER}.dat" geosite.dat

	systemd_dounit release/config/systemd/system/v2ray.service
	systemd_dounit release/config/systemd/system/v2ray@.service
}
