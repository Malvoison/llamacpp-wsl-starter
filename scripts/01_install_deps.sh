#!/usr/bin/env bash
set -euo pipefail

CUDA=0
if [[ "${1:-}" == "--cuda" ]]; then
  CUDA=1
fi

sudo apt update

# Core build deps
sudo apt install -y --no-install-recommends \
  build-essential cmake ninja-build git wget p7zip-full \
  libopenblas-dev libcurl4-openssl-dev

if [[ $CUDA -eq 1 ]]; then
  echo "[+] Installing CUDA toolkit inside WSL (cuBLAS build path)"
  # Basic toolkit from Ubuntu repos; for latest, prefer NVIDIA WSL docs
  sudo apt install -y nvidia-cuda-toolkit
  echo "[i] If you need a newer CUDA than Ubuntu repos provide, follow NVIDIA WSL docs."
else
  echo "[i] Skipping CUDA install. CPU/OpenBLAS build will be used."
fi

echo "[✓] Dependencies installed."