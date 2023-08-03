# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	aead@0.4.3
	aes@0.7.5
	aes-gcm@0.9.2
	aho-corasick@1.1.1
	anyhow@1.0.75
	async-http-proxy@1.2.5
	async-socks5@0.5.1
	async-trait@0.1.73
	atty@0.2.14
	autocfg@1.1.0
	axum@0.6.20
	axum-core@0.3.4
	backoff@0.4.0
	backtrace@0.3.69
	base64@0.13.1
	base64@0.21.4
	bincode@1.3.3
	bitflags@1.3.2
	bitflags@2.4.0
	blake2@0.10.6
	block-buffer@0.10.4
	byteorder@1.4.3
	bytes@1.5.0
	cc@1.0.83
	cfg-if@1.0.0
	chacha20@0.8.2
	chacha20poly1305@0.9.1
	cipher@0.3.0
	clap@3.2.25
	clap_derive@3.2.25
	clap_lex@0.2.4
	console-api@0.5.0
	console-subscriber@0.1.10
	core-foundation@0.9.3
	core-foundation-sys@0.8.4
	cpufeatures@0.2.9
	crc32fast@1.3.2
	crossbeam-channel@0.5.8
	crossbeam-utils@0.8.16
	crypto-common@0.1.6
	ctr@0.7.0
	curve25519-dalek@4.1.1
	curve25519-dalek-derive@0.1.0
	data-encoding@2.4.0
	deranged@0.3.8
	digest@0.10.7
	either@1.9.0
	enum-iterator@1.4.1
	enum-iterator-derive@1.2.1
	errno@0.3.3
	errno-dragonfly@0.1.2
	fastrand@2.0.1
	fdlimit@0.2.1
	fiat-crypto@0.2.1
	filetime@0.2.22
	flate2@1.0.27
	fnv@1.0.7
	foreign-types@0.3.2
	foreign-types-shared@0.1.1
	form_urlencoded@1.2.0
	fsevent-sys@4.1.0
	futures@0.3.28
	futures-channel@0.3.28
	futures-core@0.3.28
	futures-io@0.3.28
	futures-macro@0.3.28
	futures-sink@0.3.28
	futures-task@0.3.28
	futures-util@0.3.28
	generic-array@0.14.7
	getrandom@0.2.10
	getset@0.1.2
	ghash@0.4.4
	gimli@0.28.0
	git2@0.16.1
	h2@0.3.21
	hashbrown@0.12.3
	hdrhistogram@7.5.2
	heck@0.4.1
	hermit-abi@0.1.19
	hermit-abi@0.3.3
	hex@0.4.3
	http@0.2.9
	http-body@0.4.5
	httparse@1.8.0
	httpdate@1.0.3
	humantime@2.1.0
	hyper@0.14.27
	hyper-timeout@0.4.1
	idna@0.4.0
	indexmap@1.9.3
	inotify@0.9.6
	inotify-sys@0.1.5
	instant@0.1.12
	itertools@0.10.5
	itoa@1.0.9
	jobserver@0.1.26
	kqueue@1.0.8
	kqueue-sys@1.0.4
	lazy_static@1.4.0
	libc@0.2.148
	libgit2-sys@0.14.2+1.5.1
	libz-sys@1.1.12
	linux-raw-sys@0.4.8
	lock_api@0.4.10
	log@0.4.20
	matchers@0.1.0
	matchit@0.7.3
	memchr@2.6.3
	mime@0.3.17
	minimal-lexical@0.2.1
	miniz_oxide@0.7.1
	mio@0.8.8
	native-tls@0.2.11
	nom@7.1.3
	notify@5.2.0
	nu-ansi-term@0.46.0
	num-traits@0.2.16
	num_cpus@1.16.0
	object@0.32.1
	once_cell@1.18.0
	opaque-debug@0.3.0
	openssl@0.10.57
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.93
	os_str_bytes@6.5.1
	overload@0.1.1
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	percent-encoding@2.3.0
	pin-project@1.1.3
	pin-project-internal@1.1.3
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.27
	platforms@3.1.2
	poly1305@0.7.2
	polyval@0.5.3
	ppv-lite86@0.2.17
	proc-macro-error@1.0.4
	proc-macro-error-attr@1.0.4
	proc-macro2@1.0.67
	prost@0.11.9
	prost-derive@0.11.9
	prost-types@0.11.9
	quote@1.0.33
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.3.5
	regex@1.9.6
	regex-automata@0.1.10
	regex-automata@0.3.9
	regex-syntax@0.6.29
	regex-syntax@0.7.5
	rustc-demangle@0.1.23
	rustc_version@0.4.0
	rustix@0.38.15
	rustversion@1.0.14
	ryu@1.0.15
	same-file@1.0.6
	schannel@0.1.22
	scopeguard@1.2.0
	security-framework@2.9.2
	security-framework-sys@2.9.1
	semver@1.0.19
	serde@1.0.188
	serde_derive@1.0.188
	serde_json@1.0.107
	sha1@0.10.6
	sha2@0.10.8
	sharded-slab@0.1.6
	signal-hook-registry@1.4.1
	slab@0.4.9
	smallvec@1.11.1
	snow@0.9.3
	snowstorm@0.4.0
	socket2@0.4.9
	socket2@0.5.4
	strsim@0.10.0
	subtle@2.5.0
	syn@1.0.109
	syn@2.0.37
	sync_wrapper@0.1.2
	tempfile@3.8.0
	termcolor@1.3.0
	textwrap@0.16.0
	thiserror@1.0.49
	thiserror-impl@1.0.49
	thread_local@1.1.7
	time@0.3.29
	time-core@0.1.2
	time-macros@0.2.15
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio@1.32.0
	tokio-io-timeout@1.2.0
	tokio-macros@2.1.0
	tokio-native-tls@0.3.1
	tokio-stream@0.1.14
	tokio-tungstenite@0.20.1
	tokio-util@0.7.9
	toml@0.5.11
	tonic@0.9.2
	tower@0.4.13
	tower-layer@0.3.2
	tower-service@0.3.2
	tracing@0.1.37
	tracing-attributes@0.1.26
	tracing-core@0.1.31
	tracing-log@0.1.3
	tracing-subscriber@0.3.17
	try-lock@0.2.4
	tungstenite@0.20.1
	typenum@1.17.0
	unicode-bidi@0.3.13
	unicode-ident@1.0.12
	unicode-normalization@0.1.22
	universal-hash@0.4.0
	url@2.4.1
	utf-8@0.7.6
	valuable@0.1.0
	vcpkg@0.2.15
	vergen@7.5.1
	version_check@0.9.4
	walkdir@2.4.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	zeroize@1.6.0
"

inherit cargo systemd

DESCRIPTION="A reverse proxy for NAT traversal"
HOMEPAGE="https://github.com/rapiz1/rathole"
SRC_URI="https://github.com/rapiz1/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	dodoc README.md
	dobin target/release/${PN}

	insinto /etc/${PN}
	doins examples/minimal/*.toml

	insinto /usr/share/${PN}
	doins -r examples/{iperf3, minimal, noise_nk, tls, udp, unified, use_proxy}

	systemd_dounit examples/systemd/*.service
}
