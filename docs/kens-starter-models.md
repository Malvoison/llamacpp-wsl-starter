# Ken’s Starter Models (GGUF picks)

Below are solid, commonly used GGUF options with rough guidance for CPU/GPU use in WSL.
Quant suggestions balance quality vs. RAM/VRAM. Your mileage may vary.

> **Rule of thumb**: If you’re CPU-only, start tiny (≤3B). With NVIDIA+CUDA in WSL, 7B–8B is comfy if you have enough VRAM; push larger only if you know you have headroom.

## Smoke tests / tiny
- **TinyLlama 1.1B Chat (permissive)**  
  Repo: `TinyLlama/TinyLlama-1.1B-Chat-v1.0`  
  GGUF: TheBloke’s `Q5_K_M` or `Q4_K_M`  
  Use: sanity-check builds, fast CLI tests.

## General chat, small
- **Phi-3 Mini 3.8B Instruct**  
  GGUF: look for `Q4_K_M` (CPU ok), `Q5_K_M` (nicer).  
  Good balance of quality/speed for small footprint.

## General chat, mainstream
- **Mistral 7B Instruct v0.2**  
  GGUF: `Q4_K_M` (CPU viable), `Q5_K_M` (GPU recommended).  
  GPU layers: ~30–35 as a starting point for 8–12GB VRAM.

- **Llama 3 8B Instruct** *(license-gated; check Meta’s terms)*  
  GGUF: `Q4_K_M` or `Q5_K_M`.  
  GPU layers: ~30–35 typical.

## Coding helpers
- **Qwen2.5-Coder 7B Instruct** or **DeepSeek-Coder 6.7B**  
  GGUF: `Q4_K_M` (CPU ok), `Q5_K_M` (GPU nicer).  
  For tighter prompts, raise context `--ctx-size 8192+`.

## Bigger (only if you have VRAM & RAM)
- **Llama 3 8B/70B**, **Mixtral 8x7B**: these are heavier. Stay with 8B unless you’re sure of your memory budget.

### Tips
- If you hit OOM: use a heavier quant (Q4_K_M) or smaller model.
- Latency too high? Reduce `--ctx-size`, `--n-gpu-layers`, or move to a smaller model.
- Keep models in `./models/` and never commit them.

### One-liners with `just`
```bash
just dl "mistralai/Mistral-7B-Instruct-v0.2" Q5_K_M   "https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q5_K_M.gguf"

just server model=models/mistral-7b-instruct-v0.2.Q5_K_M.gguf gpu_layers=35
```