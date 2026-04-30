#!/usr/bin/env bash
# Deploy the banking demo via Helm into a namespace.
# Usage: ./scripts/deploy.sh [namespace] [tag]
#   namespace defaults to 'banking-demo', tag defaults to 'local'
set -euo pipefail

NAMESPACE="${1:-banking-demo}"
TAG="${2:-local}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHART_DIR="$ROOT_DIR/chart"

if [[ ! -f "$CHART_DIR/Chart.yaml" ]]; then
  echo "Chart not found at $CHART_DIR (Chart.yaml missing)" >&2
  exit 1
fi

echo "==> Deploying chart to namespace '$NAMESPACE' (tag: $TAG)"
helm upgrade --install banking-demo "$CHART_DIR" \
  --namespace "$NAMESPACE" --create-namespace \
  --set image.tag="$TAG"

echo ""
echo "==> Waiting for rollouts..."
kubectl rollout status statefulset/banking-database -n "$NAMESPACE" --timeout=180s
kubectl rollout status deployment/banking-web-ui    -n "$NAMESPACE" --timeout=300s
kubectl rollout status deployment/banking-worker    -n "$NAMESPACE" --timeout=120s

echo ""
echo "==> Deployed to '$NAMESPACE'. Use ./scripts/port-forward.sh $NAMESPACE to reach the web UI."
