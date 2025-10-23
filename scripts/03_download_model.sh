#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <model-repo> <quant> <direct-gguf-url>"
  echo "Example:"
  echo "  $0 TinyLlama/TinyLlama-1.1B-Chat-v1.0 Q5_K_M \
    https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q5_K_M.gguf"
  exit 1
fi

REPO="$1"
QUANT="$2"
URL="$3"

mkdir -p models
FNAME="models/$(basename "${URL}")"

echo "[+] Downloading ${REPO} (${QUANT}) → ${FNAME}"
wget -O "${FNAME}" -q --show-progress "${URL}"

echo "[✓] Downloaded: ${FNAME}"