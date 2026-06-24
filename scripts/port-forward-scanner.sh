#!/usr/bin/env bash
# Port-forward the scanner UI. Ctrl-C to stop.
# Usage: ./scripts/port-forward-scanner.sh [namespace]  (default: b2s)
set -euo pipefail

NAMESPACE="${1:-bjorn2scan}"

echo "==> Port-forwarding scanner-ui in namespace '$NAMESPACE'"
echo "    http://localhost:8081"
echo ""
echo "==> Press Ctrl-C to stop."
kubectl port-forward svc/bjorn2scan 8081:80 -n "$NAMESPACE"
