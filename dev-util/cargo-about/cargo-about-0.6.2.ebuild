# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.22.0
	adler@1.0.2
	aho-corasick@1.1.3
	anstream@0.6.14
	anstyle@1.0.7
	anstyle-parse@0.2.4
	anstyle-query@1.0.3
	anstyle-wincon@3.0.3
	anyhow@1.0.86
	askalono@0.4.6
	assert_cmd@2.0.14
	assert_fs@1.1.1
	autocfg@1.3.0
	backtrace@0.3.72
	base64@0.22.1
	bitflags@2.5.0
	block-buffer@0.10.4
	bstr@1.9.1
	bumpalo@3.16.0
	byteorder@1.5.0
	bytes@1.6.0
	camino@1.1.7
	cargo-platform@0.1.8
	cargo_metadata@0.18.1
	cc@1.0.98
	cd@0.3.0
	cfg-expr@0.15.8
	cfg-if@1.0.0
	clap@4.5.4
	clap_builder@4.5.2
	clap_derive@4.5.4
	clap_lex@0.7.0
	codespan@0.11.1
	codespan-reporting@0.11.1
	colorchoice@1.0.1
	cpufeatures@0.2.12
	crc32fast@1.4.2
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	crypto-common@0.1.6
	deranged@0.3.11
	difflib@0.4.0
	digest@0.10.7
	doc-comment@0.3.3
	either@1.12.0
	equivalent@1.0.1
	errno@0.3.9
	fastrand@2.1.0
	fern@0.6.2
	fixedbitset@0.4.2
	flate2@1.0.30
	float-cmp@0.9.0
	fnv@1.0.7
	form_urlencoded@1.2.1
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-io@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	generic-array@0.14.7
	getrandom@0.2.15
	gimli@0.29.0
	globset@0.4.14
	globwalk@0.9.1
	handlebars@5.1.2
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.9
	home@0.5.9
	http@1.1.0
	http-body@1.0.0
	http-body-util@0.1.1
	httparse@1.8.0
	hyper@1.3.1
	hyper-rustls@0.26.0
	hyper-util@0.1.5
	idna@0.5.0
	ignore@0.4.22
	indexmap@2.2.6
	ipnet@2.9.0
	is_terminal_polyfill@1.70.0
	itoa@1.0.11
	jobserver@0.1.31
	js-sys@0.3.69
	krates@0.16.10
	lazy_static@1.4.0
	libc@0.2.155
	libmimalloc-sys@0.1.38
	linux-raw-sys@0.4.14
	lock_api@0.4.12
	log@0.4.21
	memchr@2.7.2
	mimalloc@0.1.42
	mime@0.3.17
	miniz_oxide@0.7.3
	mio@0.8.11
	normalize-line-endings@0.3.0
	nu-ansi-term@0.50.0
	num-conv@0.1.0
	num-traits@0.2.19
	num_cpus@1.16.0
	object@0.35.0
	once_cell@1.19.0
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	paste@1.0.15
	percent-encoding@2.3.1
	pest@2.7.10
	pest_derive@2.7.10
	pest_generator@2.7.10
	pest_meta@2.7.10
	petgraph@0.6.5
	pin-project@1.1.5
	pin-project-internal@1.1.5
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	pkg-config@0.3.30
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	predicates@3.1.0
	predicates-core@1.0.6
	predicates-tree@1.0.9
	proc-macro2@1.0.84
	quote@1.0.36
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rayon@1.10.0
	rayon-core@1.12.1
	redox_syscall@0.5.1
	regex@1.10.4
	regex-automata@0.4.6
	regex-syntax@0.8.3
	reqwest@0.12.4
	ring@0.17.8
	rmp@0.8.14
	rmp-serde@0.14.4
	rustc-demangle@0.1.24
	rustix@0.38.34
	rustls@0.22.4
	rustls-pemfile@2.1.2
	rustls-pki-types@1.7.0
	rustls-webpki@0.102.4
	ryu@1.0.18
	same-file@1.0.6
	scopeguard@1.2.0
	semver@1.0.23
	serde@1.0.203
	serde_derive@1.0.203
	serde_json@1.0.117
	serde_spanned@0.6.6
	serde_urlencoded@0.7.1
	sha2@0.10.8
	slab@0.4.9
	smallvec@1.13.2
	socket2@0.5.7
	spdx@0.10.6
	spin@0.9.8
	static_assertions@1.1.0
	strsim@0.11.1
	subtle@2.5.0
	syn@2.0.66
	sync_wrapper@0.1.2
	tempfile@3.10.1
	termcolor@1.4.1
	termtree@0.4.1
	thiserror@1.0.61
	thiserror-impl@1.0.61
	time@0.3.36
	time-core@0.1.2
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio@1.38.0
	tokio-rustls@0.25.0
	toml@0.8.13
	toml_datetime@0.6.6
	toml_edit@0.22.13
	tower@0.4.13
	tower-layer@0.3.2
	tower-service@0.3.2
	tracing@0.1.40
	tracing-core@0.1.32
	try-lock@0.2.5
	twox-hash@1.6.3
	typenum@1.17.0
	ucd-trie@0.1.6
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-width@0.1.12
	untrusted@0.9.0
	url@2.5.0
	utf8parse@0.2.1
	version_check@0.9.4
	wait-timeout@0.2.0
	walkdir@2.5.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen@0.2.92
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-futures@0.4.42
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-shared@0.2.92
	web-sys@0.3.69
	webpki-roots@0.26.1
	winapi-util@0.1.8
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
	winnow@0.6.9
	winreg@0.52.0
	zeroize@1.8.1
	zstd@0.11.2+zstd.1.5.2
	zstd-safe@5.0.2+zstd.1.5.2
	zstd-sys@2.0.10+zstd.1.5.6
"

inherit cargo

DESCRIPTION="Cargo plugin to generate list of all licenses for a crate"
HOMEPAGE="https://github.com/EmbarkStudios/cargo-about"
SRC_URI="https://github.com/EmbarkStudios/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

QA_FLAGS_IGNORED="usr/bin/${PN}"
