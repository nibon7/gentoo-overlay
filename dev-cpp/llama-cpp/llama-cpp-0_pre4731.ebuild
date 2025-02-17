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
KEYWORDS="~amd64"
IUSE="blas curl lto opencl openmp server test vulkan"
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

DEPEND="blas? ( sci-libs/openblas )
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

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DLLAMA_BUILD_COMMON=ON
		-DLLAMA_BUILD_EXAMPLES="$(usex server ON OFF)"
		-DLLAMA_BUILD_SERVER="$(usex server ON OFF)"
		-DLLAMA_BUILD_TESTS="$(usex test ON OFF)"
		-DLLAMA_BUILD_NUMBER="${MY_PV}"
		-DLLAMA_CURL="$(usex curl ON OFF)"
		-DGGML_BLAS="$(usex blas ON OFF)"
		$(usev blas -DGGML_BLAS_VENDOR=OpenBLAS)
		-DGGML_CUDE=OFF
		-DGGML_HIP=OFF
		-DGGML_LTO="$(usex lto ON OFF)"
		-DGGML_SYCL=OFF
		-DGGML_OPENCL="$(usex opencl ON OFF)"
		-DGGML_OPENMP="$(usex openmp ON OFF)"
		-DGGML_VULKAN="$(usex vulkan ON OFF)"
		$(usev cpu_flags_x86_avx -DGGML_AVX=ON)
		$(usev cpu_flags_x86_avx2 -DGGML_AVX2=ON)
		$(usev cpu_flags_x86_avx512bw -DGGML_AVX512=ON)
		$(usev cpu_flags_x86_avx512cd -DGGML_AVX512=ON)
		$(usev cpu_flags_x86_avx512dq -DGGML_AVX512=ON)
		$(usev cpu_flags_x86_avx512f -DGGML_AVX512=ON)
		$(usev cpu_flags_x86_avx512vl -DGGML_AVX512=ON)
		$(usev cpu_flags_x86_avx512_bf16 -DGGML_AVX512_BF16=ON)
		$(usev cpu_flags_x86_avx512vbmi -DGGML_AVX512_VBMI=ON)
		$(usev cpu_flags_x86_avx512_vnni -DGGML_AVX512_VNNI=ON)
		$(usev cpu_flags_x86_f16c -DGGML_F16C=ON)
		$(usev cpu_flags_x86_fma3 -DGGML_FMA=ON)
		$(usev cpu_flags_x86_sse4_2 -DGGML_SSE42=ON)
	)

	cmake_src_configure
}
