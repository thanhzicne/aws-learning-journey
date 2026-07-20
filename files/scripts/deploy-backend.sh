#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="ecommerce-api:latest"
CONTAINER_NAME="ecommerce-api"

sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable --now docker

sudo docker build -f static/files/docker/Dockerfile -t "${IMAGE_NAME}" .
sudo docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true
sudo docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  -p 80:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  "${IMAGE_NAME}"
