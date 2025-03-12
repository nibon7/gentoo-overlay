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
KEYWORDS="~amd64 ~arm64"
IUSE="blas blis curl examples hbm lto opencl openmp rpc server test vulkan"

#CPU_FLAGS_RISCV=( rvv )
#CPU_FLAGS_LOONG=( lasx lsx )
CPU_FLAGS_X86=(
#	amx_bf16
#	amx_int8
#	amx_tile
#	bmi2
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

REQUIRED_USE="
	blis? ( blas )
	server? ( examples )
"

usex_avx512() {
	local flags=(
		avx512bw
		avx512cd
		avx512dq
		avx512f
		avx512vl
	)

	for i in "${flags[@]}"; do
		if use "cpu_flags_x86_${i}"; then
			echo ON
			return
		fi
	done

	echo OFF
}

src_configure() {
	local mycmakeargs=(
		-DLLAMA_BUILD_COMMON=ON
		-DLLAMA_BUILD_EXAMPLES="$(usex examples)"
		-DLLAMA_BUILD_SERVER="$(usex server)"
		-DLLAMA_BUILD_TESTS="$(usex test)"
		-DLLAMA_BUILD_NUMBER="${MY_PV}"
		-DLLAMA_CURL="$(usex curl)"
		-DLLAMA_LLGUIDANCE=OFF
		-DLLAMA_SANITIZE_ADDRESS=OFF
		-DLLAMA_SANITIZE_THREAD=OFF
		-DLLAMA_SANITIZE_UNDEFINED=OFF
		-DLLAMA_STANDALONE=OFF

		-DGGML_CCACHE=OFF
		-DGGML_GPROF=OFF
		-DGGML_LLAMAFILE=ON
		-DGGML_RPC="$(usex rpc)"

		-DGGML_CPU=ON
		-DGGML_CPU_HBM="$(usex hbm)"
		-DGGML_CPU_AARCH64="$(usex arm64)"

		-DGGML_LTO="$(usex lto)"
		-DGGML_NATIVE=OFF

		-DGGML_BLAS="$(usex blas)"
		-DGGML_BLAS_VENDOR="$(usex blis FLAME OpenBLAS)"
		-DGGML_CANN=OFF
		-DGGML_CUDA=OFF
		-DGGML_HIP=OFF
		-DGGML_KOMPUTE=OFF
		-DGGML_MUSA=OFF
		-DGGML_SYCL=OFF
		-DGGML_METAL=OFF
		-DGGML_OPENCL="$(usex opencl)"
		-DGGML_OPENMP="$(usex openmp)"
		-DGGML_VULKAN="$(usex vulkan)"

		-DGGML_RVV=OFF

		-DGGML_LASX=OFF
		-DGGML_LSX=OFF

		-DGGML_AMX_BF16=OFF
		-DGGML_AMX_INT8=OFF
		-DGGML_AMX_TILE=OFF
		-DGGML_BMI2=OFF

		-DGGML_AVX="$(usex cpu_flags_x86_avx)"
		-DGGML_AVX2="$(usex cpu_flags_x86_avx2)"
		-DGGML_AVX512="$(usex_avx512)"
		-DGGML_AVX512_BF16="$(usex cpu_flags_x86_avx512_bf16)"
		-DGGML_AVX512_VBMI="$(usex cpu_flags_x86_avx512vbmi)"
		-DGGML_AVX512_VNNI="$(usex cpu_flags_x86_avx512_vnni)"
		-DGGML_F16C="$(usex cpu_flags_x86_f16c)"
		-DGGML_FMA="$(usex cpu_flags_x86_fma3)"
		-DGGML_SSE42="$(usex cpu_flags_x86_sse4_2)"
	)

	cmake_src_configure
}
