# justfile (Ken style). Install `just` for a nicer UX: https://github.com/casey/just

set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

MODEL := "models/tinyllama-1.1b-chat-v1.0.Q5_K_M.gguf"
GPU_LAYERS := "35"
CTX := "4096"

deps:
  ./scripts/01_install_deps.sh

deps-cuda:
  ./scripts/01_install_deps.sh --cuda

build:
  ./scripts/02_build.sh

build-cuda:
  ./scripts/02_build.sh --cuda

dl REPO QUANT URL:
  ./scripts/03_download_model.sh {{REPO}} {{QUANT}} {{URL}}

chat model?={{MODEL}}:
  ./scripts/04_run_chat.sh {{model}} --ctx-size {{CTX}}

server model?={{MODEL}} gpu_layers?={{GPU_LAYERS}}:
  ./scripts/05_run_server.sh {{model}} --ctx-size {{CTX}} --gpu-layers {{gpu_layers}}

docker-build:
  docker compose -f infra/docker-compose.yml build

docker-up:
  docker compose -f infra/docker-compose.yml up -d

docker-down:
  docker compose -f infra/docker-compose.yml down