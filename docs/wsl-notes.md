# WSL notes

- This guide assumes **WSL2** (not WSL1).
- GPU acceleration (CUDA) in WSL requires:
  - NVIDIA GPU on Windows
  - Recent Windows NVIDIA driver
  - CUDA toolkit inside WSL (installed by script if you pass `--cuda`, or via NVIDIA docs)

Check `ldconfig -p | grep cuda` and `nvcc --version` to confirm toolchain, and ensure the build
was done with `-DGGML_CUDA=ON`.