#!/usr/bin/env bash
# Cut a release: bump chart/Chart.yaml and chart/values.yaml to a new
# version, commit the bump, tag it, and push main + tag to origin
# (which triggers the release workflow).
#
# Must be run from the main branch.
#
# Usage: ./scripts/release.sh <version>
#   <version> is SemVer-style without a leading 'v' (e.g., 1.0.0, 2.1.0-rc1).
#   A leading 'v' is stripped if provided.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  echo "Example: $0 1.0.0" >&2
  exit 1
fi

VERSION="${1#v}"

if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9.-]+)?$ ]]; then
  echo "Error: version '$VERSION' is not SemVer-style (e.g. 1.0.0 or 1.0.0-rc1)" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHART_FILE="$ROOT_DIR/chart/Chart.yaml"
VALUES_FILE="$ROOT_DIR/chart/values.yaml"
TAG="v$VERSION"

BRANCH=$(git -C "$ROOT_DIR" rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH" != "main" ]]; then
  echo "Error: releases must be cut from main (currently on '$BRANCH')." >&2
  exit 1
fi

if ! git -C "$ROOT_DIR" diff --quiet || ! git -C "$ROOT_DIR" diff --cached --quiet; then
  echo "Error: working tree has uncommitted changes. Commit or stash first." >&2
  exit 1
fi

if git -C "$ROOT_DIR" rev-parse "$TAG" >/dev/null 2>&1; then
  echo "Error: tag $TAG already exists" >&2
  exit 1
fi

echo "==> Bumping chart and values to $VERSION"

# Chart.yaml: version + appVersion at top level
sed -i.bak -E \
  -e "s/^version: .*/version: $VERSION/" \
  -e "s/^appVersion: .*/appVersion: \"$VERSION\"/" \
  "$CHART_FILE"
rm "$CHART_FILE.bak"

# values.yaml: image.tag (the only 2-space-indented `tag:` line in the file)
sed -i.bak -E \
  -e "s/^([[:space:]]+tag: ).*/\1$VERSION/" \
  "$VALUES_FILE"
rm "$VALUES_FILE.bak"

echo ""
echo "==> Diff:"
git -C "$ROOT_DIR" --no-pager diff -- chart/Chart.yaml chart/values.yaml

echo ""
echo "==> Committing release commit"
git -C "$ROOT_DIR" add chart/Chart.yaml chart/values.yaml
git -C "$ROOT_DIR" commit -m "Release $TAG"

echo ""
echo "==> Tagging $TAG"
git -C "$ROOT_DIR" tag -a "$TAG" -m "Release $TAG"

echo ""
echo "==> Pushing main and $TAG to origin"
git -C "$ROOT_DIR" push origin main "$TAG"

echo ""
echo "==> Done. The release workflow will publish images and the chart to GHCR."
