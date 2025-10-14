# Model basics (GGUF & picks)

- **GGUF** is the file format used by `llama.cpp`.
- Pick **instruct/chat** variants for conversational use.
- **Quantization** (e.g., Q4_K_M, Q5_K_M) trades size/speed vs. quality.
- Safe places to find GGUF: TheBloke, bartowski, MaziyarPanahi on Hugging Face.

## Quick picks

- **Tiny**: TinyLlama 1.1B Chat (fast sanity checks)
- **General**: Llama 3 8B Instruct (license-gated; check Meta’s terms)
- **Alt general**: Mistral 7B Instruct v0.2
- **Coding**: DeepSeek-Coder 6.7B Instruct, Qwen2.5-Coder 7B

Put models under `models/` and use scripts with the path.