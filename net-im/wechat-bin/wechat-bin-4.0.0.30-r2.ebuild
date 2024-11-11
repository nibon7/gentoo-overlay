# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop optfeature unpacker xdg

DESCRIPTION="WeChat from Tencent"
HOMEPAGE="https://linux.weixin.qq.com"
SRC_URI="
	amd64? ( https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb -> WeChatLinux-${PV}-x86_64.deb )
	arm64? ( https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.deb -> WeChatLinux-${PV}-arm64.deb )
	loong? ( https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_LoongArch.deb -> WeChatLinux-${PV}-LoongArch.deb )
"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64 ~loong"
RESTRICT="bindist mirror strip"

BDEPEND="
	dev-util/patchelf
"

RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/nss
	media-libs/libpulse
	media-libs/mesa
	virtual/jack
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libxkbcommon[X]
	x11-libs/libXrandr
	x11-libs/pango
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
"

QA_PREBUILT="*"

src_prepare() {
	default

	local files=(
		libconfService.so
		libilink2.so
		libilink_network.so
		libvoipChannel.so
		libvoipCodec.so
		libwxtrans.so
		RadiumWMPF/runtime/libilink2.so
		RadiumWMPF/runtime/libilink_network.so
	)

	for f in "${files[@]}"; do
		patchelf --set-rpath '$ORIGIN' opt/wechat/${f} || die
	done

	find opt/wechat/vlc_plugins -type f \
		-exec patchelf --set-rpath '$ORIGIN:$ORIGIN/../..' '{}' \+ || die
}

src_install() {
	insinto /usr/share
	doins -r usr/share/icons

	insinto /opt
	doins -r opt/wechat

	local files=(
		crashpad_handler
		wechat
		wxocr
		wxplayer
		RadiumWMPF/runtime/WeChatAppEx
		RadiumWMPF/runtime/WeChatAppEx_crashpad_handler
	)

	for f in "${files[@]}"; do
		fperms 0755 /opt/wechat/${f}
	done

	sed -e 's|^Icon=.*|Icon=wechat|' \
		-e 's|^Exec=|Exec=env QT_AUTO_SCREEN_SCALE_FACTOR=1 QT_QPA_PLATFORM="wayland;xcb" |' \
		-e 's|^Categories=.*|Categories=Network;InstantMessaging;Chat;|' \
		-i usr/share/applications/wechat.desktop || die

	domenu usr/share/applications/wechat.desktop
	dosym ../../opt/wechat/wechat /usr/bin/wechat
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "Chinese font support" "media-fonts/noto-cjk"
	optfeature "Emoji support" "media-fonts/noto-emoji"
}

pkg_postrm() {
	xdg_pkg_postrm
}
