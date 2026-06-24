#!/usr/bin/env bash
# Build all service images locally and load them into the active kind cluster.
# Usage: ./scripts/build.sh [tag]
#   default tag: image.tag from chart/values.yaml (the version of the
#   currently checked-out commit). Pass an explicit tag to override.
#
# Chainguard library credentials are read from these env vars:
#   CG_NPM_USER, CG_NPM_PASS    (Chainguard npm mirror basic auth)
#   CG_PYPI_USER, CG_PYPI_PASS  (Chainguard PyPI mirror basic auth)
# All four must be set. The script composes them into the two values the
# Dockerfile build secrets actually consume.
set -euo pipefail

: "${CG_NPM_USER:?required (Chainguard npm username)}"
: "${CG_NPM_PASS:?required (Chainguard npm password)}"
: "${CG_PYPI_USER:?required (Chainguard PyPI username)}"
: "${CG_PYPI_PASS:?required (Chainguard PyPI password)}"

export CG_NPM_AUTH_B64
CG_NPM_AUTH_B64=$(printf '%s' "$CG_NPM_USER:$CG_NPM_PASS" | base64 | tr -d '\n')

# pip's PIP_INDEX_URL embeds credentials in the URL, so userinfo must be
# percent-encoded — special chars (/, @, :, ?, #, %) would otherwise break
# URL parsing and pip would silently hit an unauthenticated/wrong endpoint.
urlencode() { python3 -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$1"; }
CG_PYPI_USER_ENC=$(urlencode "$CG_PYPI_USER")
CG_PYPI_PASS_ENC=$(urlencode "$CG_PYPI_PASS")
export CG_PIP_INDEX_URL="https://${CG_PYPI_USER_ENC}:${CG_PYPI_PASS_ENC}@libraries.cgr.dev/python/simple/"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

DEFAULT_TAG=$(grep -E '^[[:space:]]+tag:' "$ROOT_DIR/chart/values.yaml" | head -1 | awk '{print $2}')
TAG="${1:-$DEFAULT_TAG}"

SERVICES=(banking-web-ui banking-database banking-worker)

echo "==> Building images (tag: $TAG)"
for svc in "${SERVICES[@]}"; do
  docker build \
    --secret id=cg_npm_auth_b64,env=CG_NPM_AUTH_B64 \
    --secret id=cg_pip_index_url,env=CG_PIP_INDEX_URL \
    -t "${svc}:${TAG}" \
    "$ROOT_DIR/$svc"
done

echo ""
echo "==> Loading images into kind"
for svc in "${SERVICES[@]}"; do
  kind load docker-image "${svc}:${TAG}" --name kind
done

echo ""
echo "==> Build + load complete (tag: $TAG)"
