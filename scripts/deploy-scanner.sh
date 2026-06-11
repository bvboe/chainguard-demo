#!/usr/bin/env bash
# Deploy the bjorn2scan vulnerability scanner via Helm into a namespace.
# Usage: ./scripts/deploy-scanner.sh [namespace]
#   namespace defaults to 'b2s'
set -euo pipefail

NAMESPACE="${1:-b2s}"
CHART="oci://ghcr.io/bvboe/b2s-go/bjorn2scan"

echo "==> Deploying bjorn2scan to namespace '$NAMESPACE'"
helm upgrade --install bjorn2scan "$CHART" \
  --namespace "$NAMESPACE" --create-namespace \
  --set clusterName="Kubernetes" \
  --wait --timeout 5m

echo ""
echo "==> Deployed to '$NAMESPACE'. Use ./scripts/port-forward-scanner.sh $NAMESPACE to reach the dashboard."
