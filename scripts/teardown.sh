#!/usr/bin/env bash
# Delete a deployment namespace.
# Usage: ./teardown.sh [namespace]  (default: banking-demo)
set -euo pipefail

NAMESPACE="${1:-banking-demo}"

echo "==> Deleting namespace '$NAMESPACE'"
kubectl delete namespace "$NAMESPACE" --wait --ignore-not-found
echo "==> Done."
