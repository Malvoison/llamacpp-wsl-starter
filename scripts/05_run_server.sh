#!/usr/bin/env bash
set -euo pipefail

MODEL="${1:-}"
shift || true

if [[ -z "${MODEL}" && -f ".env" ]]; then
  source .env
fi

MODEL="${MODEL:-${MODEL_PATH:-}}"
PORT="${PORT:-8080}"

if [[ -z "${MODEL}" ]]; then
  echo "Usage: $0 <path-to-model.gguf> [llama-server args...]"
  echo "Or set MODEL_PATH in .env"
  exit 1
fi

BIN="./llama-bin/llama-server"
if [[ ! -x "${BIN}" ]]; then
  echo "llama-server not found. Did you run ./scripts/02_build.sh ?"
  exit 1
fi

echo "[i] Starting server on :${PORT} (OpenAI compatible)"
exec "${BIN}" -m "${MODEL}" --host 127.0.0.1 --port "${PORT}" "$@"