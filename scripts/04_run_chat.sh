#!/usr/bin/env bash
set -euo pipefail

MODEL="${1:-}"
shift || true

if [[ -z "${MODEL}" && -f ".env" ]]; then
  source .env
fi

MODEL="${MODEL:-${MODEL_PATH:-}}"
if [[ -z "${MODEL}" ]]; then
  echo "Usage: $0 <path-to-model.gguf> [llama-cli args...]"
  echo "Or set MODEL_PATH in .env"
  exit 1
fi

BIN="./llama-bin/llama-cli"
if [[ ! -x "${BIN}" ]]; then
  echo "llama-cli not found. Did you run ./scripts/02_build.sh ?"
  exit 1
fi

exec "${BIN}" -m "${MODEL}" -p "You are a helpful assistant." -n 512 "$@"