#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

for f in models/*.gguf; do
  echo "==> $f"
  # best-effort metadata peek (not guaranteed)
  strings "$f" | grep -m1 -E 'general.name|tokenizer.ggml.model|model_name|architect' || true
  ls -lh "$f" | awk '{print "size:", $5}'
  echo
done
