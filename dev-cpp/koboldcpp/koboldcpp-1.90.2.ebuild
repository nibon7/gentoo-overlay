# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=6.3
PYTHON_COMPAT=( python3_{10..13} )

inherit cuda python-r1 rocm

DESCRIPTION="KoboldCpp is an easy-to-use AI text-generation software for GGML and GGUF models"
HOMEPAGE="https://github.com/lostruins/koboldcpp"
SRC_URI="https://github.com/lostruins/koboldcpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda opencl avx2 hip test vulkan"

CPU_FLAGS_X86=(
	avx
	avx2
	f16c
	fma3
	sse3
	ssse3
)

IUSE+=" $(printf "cpu_flags_x86_%s\n" ${CPU_FLAGS_X86[@]})"

RESTRICT="!test? ( test )"

DEPEND="
	${PYTHON_DEPS}
	dev-python/psutil[${PYTHON_USEDEP}]
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	hip? (
			>=dev-util/hip-${ROCM_VERSION}
			>=sci-libs/rocBLAS-${ROCM_VERSION}[${ROCM_USEDEP}]
	)
	opencl? (
			virtual/opencl
			sci-libs/clblast
	)
	vulkan? (
		media-libs/shaderc
		media-libs/vulkan-loader
	)
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	hip? ( ${ROCM_REQUIRED_USE} )
	avx2? ( amd64 cpu_flags_x86_avx2 cpu_flags_x86_fma3 cpu_flags_x86_f16c )
	amd64? ( cpu_flags_x86_avx cpu_flags_x86_sse3 cpu_flags_x86_ssse3 )
"

QA_FLAGS_IGNORED="usr/share/${PN}/.*.so"

src_prepare() {
	use cuda && cuda_src_prepare

	default
}

src_compile() {
	emake \
		LLAMA_PORTABLE=1 \
		$(usev !avx2 LLAMA_NOAVX2=1) \
		$(usev cuda LLAMA_CUBLAS=1) \
		$(usev hip LLAMA_HIPBLAS=1) \
		$(usev opencl LLAMA_CLBLAST=1) \
		$(usev vulkan LLAMA_VULKAN=1)
}

src_install() {
	insinto /usr/share/${PN}
	doins -r \
		*.so \
		*.embd \
		json_to_gbnf.py \
		koboldcpp.py \
		kcpp_adapters/

	newbin "${FILESDIR}"/${PN}.sh ${PN}
}
