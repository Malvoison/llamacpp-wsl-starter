# 🦙 llama.cpp on WSL — Starter Repo

A batteries-included, **step-by-step guide** (plus scripts) to build and run `llama.cpp` on **WSL2 (Ubuntu)**.
Works great for **CPU** by default, and includes **optional CUDA/cuBLAS** steps if you have an NVIDIA GPU exposed to WSL.

> Tested on Ubuntu 22.04/24.04 on WSL2. If you're brand new to models, see `docs/model-basics.md`.

---

## 0) Pre-flight (in Windows + WSL)

- Windows 10/11 with **WSL2** and **Ubuntu** distro.
- Recommended: update Windows NVIDIA driver (if you plan to use CUDA).
- In WSL:
  ```bash
  sudo apt update && sudo apt upgrade -y
  ```

---

## 1) Install build dependencies (WSL Ubuntu)

Run:

```bash
./scripts/01_install_deps.sh
```

What this does:
- Installs `build-essential`, `cmake`, `ninja-build`, `git`, `wget`, `p7zip-full`
- Installs **OpenBLAS** for faster CPU math
- Optionally installs **CUDA Toolkit** for cuBLAS (skipped unless you pass `--cuda`)

---

## 2) Clone and build `llama.cpp`

```bash
./scripts/02_build.sh           # CPU build using OpenBLAS
# or
./scripts/02_build.sh --cuda    # GPU build using cuBLAS (requires CUDA on WSL)
```

Outputs into `build/` with handy launchers in `./llama-bin` (symlinks).

---

## 3) Get a GGUF model (examples included)

You can download a pre-quantized `.gguf` via:

```bash
# Example: Small, permissive model (great for smoke tests)
./scripts/03_download_model.sh TinyLlama/TinyLlama-1.1B-Chat-v1.0   Q5_K_M https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q5_K_M.gguf

# Example: Mistral 7B Instruct (you'll need enough RAM/VRAM)
./scripts/03_download_model.sh mistralai/Mistral-7B-Instruct-v0.2   Q5_K_M https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q5_K_M.gguf
```

> Tip: Place any `.gguf` under `models/` and point scripts to it via `.env` or CLI arg.

---

## 4) Chat locally (CLI)

```bash
# CPU:
./scripts/04_run_chat.sh models/tinyllama-1.1b-chat-v1.0.Q5_K_M.gguf

# GPU (cuBLAS build):
./scripts/04_run_chat.sh models/mistral-7b-instruct-v0.2.Q5_K_M.gguf --gpu-layers 35
```

Ctrl+C to exit. Add `--ctx-size 4096` etc. as you like.

---

## 5) Run an OpenAI-compatible local server

```bash
./scripts/05_run_server.sh models/mistral-7b-instruct-v0.2.Q5_K_M.gguf --gpu-layers 35
```

Then hit:
```
curl http://127.0.0.1:8080/v1/models
```
Or point tools that speak the OpenAI API at `http://127.0.0.1:8080`.

---

## 6) Repo hygiene / GitHub

- This repo **ignores `models/`** by default so you don’t push big weights.
- Use Git LFS **only** if you intentionally want to version models (not recommended).
- CI workflow checks build on Ubuntu (CPU) to ensure the guide doesn’t rot.

---

## 7) Troubleshooting

- **CUDA in WSL**: you need an NVIDIA GPU + recent Windows driver + CUDA toolkit in WSL. If `nvidia-smi` works on Windows but not in WSL, install `nvidia-cuda-toolkit` in WSL or follow NVIDIA’s WSL docs.
- If build fails, nuke and retry:
  ```bash
  rm -rf build && ./scripts/02_build.sh [--cuda]
  ```
- Memory errors? Try a smaller model or a heavier quant (e.g., `Q4_K_M` instead of `Q5_K_M`).

---

## License

The scripts/docs here are MIT. **Models** have their **own licenses**. Read them before use.

---

## Makefile / just shortcuts

```bash
make deps build
make dl REPO="mistralai/Mistral-7B-Instruct-v0.2" QUANT=Q5_K_M URL="https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q5_K_M.gguf"
make server MODEL=models/mistral-7b-instruct-v0.2.Q5_K_M.gguf GPU_LAYERS=35
```

Or with `just`:
```bash
just deps build
just dl "mistralai/Mistral-7B-Instruct-v0.2" Q5_K_M "https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q5_K_M.gguf"
just server model=models/mistral-7b-instruct-v0.2.Q5_K_M.gguf gpu_layers=35
```

## Docker (optional, one-liner)

```bash
make docker-build
MODEL=$(pwd)/models/mistral-7b-instruct-v0.2.Q5_K_M.gguf make docker-up
# then curl http://127.0.0.1:8080/v1/models
```

See `docs/kens-starter-models.md` for curated picks.