# Makefile (Ken style): common flows for llama.cpp on WSL

# Default config (override on CLI: make MODEL=... GPU_LAYERS=...)
MODEL ?= models/tinyllama-1.1b-chat-v1.0.Q5_K_M.gguf
GPU_LAYERS ?= 35
CTX ?= 4096

.PHONY: all deps deps-cuda build build-cuda clean chat server dl docker-build docker-up docker-down fmt ci

all: build

deps:
	./scripts/01_install_deps.sh

deps-cuda:
	./scripts/01_install_deps.sh --cuda

build:
	./scripts/02_build.sh

build-cuda:
	./scripts/02_build.sh --cuda

dl:
	@echo "Usage: make dl REPO='TinyLlama/TinyLlama-1.1B-Chat-v1.0' QUANT='Q5_K_M' URL='<direct gguf url>'"
	@test -n "$(REPO)" && test -n "$(QUANT)" && test -n "$(URL)" || (echo "Missing REPO/QUANT/URL"; exit 1)
	./scripts/03_download_model.sh "$(REPO)" "$(QUANT)" "$(URL)"

chat:
	./scripts/04_run_chat.sh $(MODEL) --ctx-size $(CTX)

server:
	./scripts/05_run_server.sh $(MODEL) --ctx-size $(CTX) --gpu-layers $(GPU_LAYERS)

docker-build:
	docker compose -f infra/docker-compose.yml build

docker-up:
	docker compose -f infra/docker-compose.yml up -d

docker-down:
	docker compose -f infra/docker-compose.yml down

clean:
	rm -rf build llama-bin