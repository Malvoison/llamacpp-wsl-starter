# Multi-stage build for llama.cpp (server + cli)
# Enable CUDA by passing: --build-arg ENABLE_CUDA=1
ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE} as builder

ARG ENABLE_CUDA=0
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential cmake ninja-build wget ca-certificates \
    libopenblas-dev && \
    if [ "$ENABLE_CUDA" = "1" ]; then apt-get install -y nvidia-cuda-toolkit; fi && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone --depth=1 https://github.com/ggerganov/llama.cpp.git

WORKDIR /app/llama.cpp/build
RUN if [ "$ENABLE_CUDA" = "1" ]; then \
      cmake -G Ninja -DLLAMA_CUBLAS=ON -DGGML_CUDA=ON -DCMAKE_BUILD_TYPE=Release .. ; \
    else \
      cmake -G Ninja -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS -DCMAKE_BUILD_TYPE=Release .. ; \
    fi && \
    ninja

# Runtime
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /srv

# Copy binaries
COPY --from=builder /app/llama.cpp/build/bin/llama-server /usr/local/bin/llama-server
COPY --from=builder /app/llama.cpp/build/bin/llama-cli /usr/local/bin/llama-cli

# Models mount point
VOLUME ["/models"]
EXPOSE 8080

# Default command: run server; override MODEL via env or compose
ENV MODEL=/models/model.gguf
CMD ["bash", "-lc", "llama-server -m ${MODEL} --host 0.0.0.0 --port 8080"]