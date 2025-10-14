# Troubleshooting

## Common
- Re-run `./scripts/01_install_deps.sh` after a fresh WSL upgrade.
- Delete `build/` and rebuild if cmake options changed.

## CUDA on WSL
- Ensure Windows NVIDIA driver is current.
- In WSL, `nvidia-smi` should run if the driver/toolkit bridge is correct.
- If builds succeed but runtime is slow, verify you built with `-DGGML_CUDA=ON` and pass `--gpu-layers N`.

## Models
- If you get out-of-memory, try a smaller model or heavier quant (Q4_K_M).