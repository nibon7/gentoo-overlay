# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="${PN/-/.}"
MY_PV="b${PV#0_pre}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Inference of Meta's LLaMA model (and others) in pure C/C++"
HOMEPAGE="https://github.com/ggml-org/llama.cpp"
SRC_URI="https://github.com/ggml-org/llama.cpp/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
IUSE="blas blis curl lto opencl openmp server test vulkan"
CPU_FLAGS_X86=(
	avx
	avx2
	avx512bw
	avx512cd
	avx512dq
	avx512f
	avx512vl
	avx512_bf16
	avx512vbmi
	avx512_vnni
	f16c
	fma3
	sse4_2
)

IUSE+=" $(printf "cpu_flags_x86_%s\n" ${CPU_FLAGS_X86[@]})"

RESTRICT="!test? ( test )"

DEPEND="blas? (
		!blis? ( sci-libs/openblas )
		blis? ( sci-libs/blis )
	)
	curl? ( net-misc/curl )
	opencl? ( virtual/opencl )
	openmp? ( sys-devel/gcc:=[openmp] )
	vulkan? (
		media-libs/shaderc
		media-libs/vulkan-loader
	)
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

REQUIRED_USE="blis? ( blas )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DLLAMA_BUILD_COMMON=ON
		-DLLAMA_BUILD_EXAMPLES="$(usex server ON OFF)"
		-DLLAMA_BUILD_SERVER="$(usex server ON OFF)"
		-DLLAMA_BUILD_TESTS="$(usex test ON OFF)"
		-DLLAMA_BUILD_NUMBER="${MY_PV}"
		-DLLAMA_CURL="$(usex curl ON OFF)"
		-DLLAMA_LLGUIDANCE=OFF
		-DLLAMA_SANITIZE_ADDRESS=OFF
		-DLLAMA_SANITIZE_THREAD=OFF
		-DLLAMA_SANITIZE_UNDEFINED=OFF
		-DLLAMA_STANDALONE=OFF
		-DGGML_BLAS="$(usex blas ON OFF)"
		-DGGML_BLAS_VENDOR="$(usex blis FLAME OpenBLAS)"
		-DGGML_CANN=OFF
		-DGGML_CCACHE=OFF
		-DGGML_CPU=ON
		-DGGML_CPU_AARCH64="$(usex arm64 ON OFF)"
		-DGGML_CUDE=OFF
		-DGGML_GPROF=OFF
		-DGGML_HIP=OFF
		-DGGML_KOMPUTE=OFF
		-DGGML_LASX="$(usex loong ON OFF)"
		-DGGML_LSX="$(usex loong ON OFF)"
		-DGGML_LTO="$(usex lto ON OFF)"
		-DGGML_METAL=OFF
		-DGGML_MUSA=OFF
		-DGGML_NATIVE=OFF
		-DGGML_RVV="$(usex riscv ON OFF)"
		-DGGML_SYCL=OFF
		-DGGML_OPENCL="$(usex opencl ON OFF)"
		-DGGML_OPENMP="$(usex openmp ON OFF)"
		-DGGML_RPC=OFF
		-DGGML_VULKAN="$(usex vulkan ON OFF)"
		-DGGML_AVX="$(usex cpu_flags_x86_avx ON OFF)"
		-DGGML_AVX2="$(usex cpu_flags_x86_avx2 ON OFF)"
		$(usev cpu_flags_x86_avx512bw -DGGML_AVX512=ON)
		$(usev cpu_flags_x86_avx512cd -DGGML_AVX512=ON)
		$(usev cpu_flags_x86_avx512dq -DGGML_AVX512=ON)
		$(usev cpu_flags_x86_avx512f -DGGML_AVX512=ON)
		$(usev cpu_flags_x86_avx512vl -DGGML_AVX512=ON)
		-DGGML_AVX512_BF16="$(usex cpu_flags_x86_avx512_bf16 ON OFF)"
		-DGGML_AVX512_VBMI="$(usex cpu_flags_x86_avx512vbmi ON OFF)"
		-DGGML_AVX512_VNNI="$(usex cpu_flags_x86_avx512_vnni ON OFF)"
		-DGGML_F16C="$(usex cpu_flags_x86_f16c ON OFF)"
		-DGGML_FMA="$(usex cpu_flags_x86_fma3 ON OFF)"
		-DGGML_SSE42="$(usex cpu_flags_x86_sse4_2 ON OFF)"
	)

	cmake_src_configure
}
