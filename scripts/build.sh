#!/usr/bin/env bash
# Build all service images locally and load them into the active kind cluster.
# Usage: ./scripts/build.sh [tag]   (default tag: local)
set -euo pipefail

TAG="${1:-local}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

SERVICES=(banking-web-ui banking-database banking-worker)

echo "==> Building images (tag: $TAG)"
for svc in "${SERVICES[@]}"; do
  docker build -t "${svc}:${TAG}" "$ROOT_DIR/$svc"
done

echo ""
echo "==> Loading images into kind"
for svc in "${SERVICES[@]}"; do
  kind load docker-image "${svc}:${TAG}" --name kind
done

echo ""
echo "==> Build + load complete (tag: $TAG)"
