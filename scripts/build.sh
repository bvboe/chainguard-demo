#!/usr/bin/env bash
# Build all service images locally and load them into the active kind cluster.
# Usage: ./scripts/build.sh [tag]
#   default tag: image.tag from chart/values.yaml (the version of the
#   currently checked-out commit). Pass an explicit tag to override.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

DEFAULT_TAG=$(grep -E '^[[:space:]]+tag:' "$ROOT_DIR/chart/values.yaml" | head -1 | awk '{print $2}')
TAG="${1:-$DEFAULT_TAG}"

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
