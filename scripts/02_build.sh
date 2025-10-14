#!/usr/bin/env bash
set -euo pipefail

CUDA=0
if [[ "${1:-}" == "--cuda" ]]; then
  CUDA=1
fi

mkdir -p build
cd build

if [[ $CUDA -eq 1 ]]; then
  echo "[+] Configuring CUDA/cuBLAS build"
  cmake -G Ninja -DLLAMA_CUBLAS=ON -DGGML_CUDA=ON -DCMAKE_BUILD_TYPE=Release ..
else
  echo "[+] Configuring CPU build (OpenBLAS)"
  cmake -G Ninja -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS -DCMAKE_BUILD_TYPE=Release ..
fi

ninja

cd ..
mkdir -p llama-bin
ln -sf "$(pwd)/build/bin/llama-cli" llama-bin/llama-cli
ln -sf "$(pwd)/build/bin/llama-server" llama-bin/llama-server

echo "[✓] Build complete. Binaries linked in ./llama-bin"