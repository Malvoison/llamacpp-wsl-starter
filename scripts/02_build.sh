#!/usr/bin/env bash
set -euo pipefail

# Build llama.cpp (CPU/OpenBLAS by default; CUDA/cuBLAS with --cuda)
CUDA=0
if [[ "${1:-}" == "--cuda" ]]; then
  CUDA=1
fi

# Where to place the source
SRC_DIR="external/llama.cpp"

if [[ ! -d "${SRC_DIR}" ]]; then
  echo "[+] Cloning llama.cpp into ${SRC_DIR}"
  mkdir -p external
  git clone --depth=1 https://github.com/ggerganov/llama.cpp.git "${SRC_DIR}"
else
  echo "[i] Found existing ${SRC_DIR}; pulling latest"
  git -C "${SRC_DIR}" pull --ff-only || true
fi

# Build directory inside llama.cpp
BUILD_DIR="${SRC_DIR}/build"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

if [[ $CUDA -eq 1 ]]; then
  echo "[+] Configuring CUDA/cuBLAS build"
  cmake -G Ninja -DGGML_CUDA=ON -DCMAKE_BUILD_TYPE=Release ..
else
  echo "[+] Configuring CPU build (OpenBLAS)"
  cmake -G Ninja -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS -DCMAKE_BUILD_TYPE=Release ..
fi

ninja

cd - >/dev/null
mkdir -p llama-bin
ln -sf "$(pwd)/${BUILD_DIR}/bin/llama-cli" llama-bin/llama-cli
ln -sf "$(pwd)/${BUILD_DIR}/bin/llama-server" llama-bin/llama-server

echo "[✓] Build complete. Binaries linked in ./llama-bin"
