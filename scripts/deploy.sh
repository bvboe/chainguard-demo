#!/usr/bin/env bash
# Deploy the banking demo via Helm into a namespace.
# Usage: ./scripts/deploy.sh [namespace] [tag]
#   namespace defaults to 'banking-demo'
#   tag defaults to image.tag from chart/values.yaml; pass to override
set -euo pipefail

NAMESPACE="${1:-banking-demo}"
TAG="${2:-}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHART_DIR="$ROOT_DIR/chart"

if [[ ! -f "$CHART_DIR/Chart.yaml" ]]; then
  echo "Chart not found at $CHART_DIR (Chart.yaml missing)" >&2
  exit 1
fi

# pullPolicy=Never: images are loaded into kind from the local Docker daemon
# (see scripts/build.sh), so kubelet must not try to fetch them from a registry.
HELM_ARGS=(--set image.pullPolicy=Never)
if [[ -n "$TAG" ]]; then
  HELM_ARGS+=(--set "image.tag=$TAG")
fi

echo "==> Deploying chart to namespace '$NAMESPACE'${TAG:+ (tag override: $TAG)}"
helm upgrade --install banking-demo "$CHART_DIR" \
  --namespace "$NAMESPACE" --create-namespace \
  "${HELM_ARGS[@]}"

echo ""
echo "==> Waiting for rollouts..."
kubectl rollout status statefulset/banking-database -n "$NAMESPACE" --timeout=180s
kubectl rollout status deployment/banking-web-ui    -n "$NAMESPACE" --timeout=300s
kubectl rollout status deployment/banking-worker    -n "$NAMESPACE" --timeout=120s

echo ""
echo "==> Deployed to '$NAMESPACE'. Use ./scripts/port-forward.sh $NAMESPACE to reach the web UI."
