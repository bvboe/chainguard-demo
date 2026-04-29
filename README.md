# Banking Demo — v1

A small banking application used to demonstrate the value of migrating to Chainguard. **v1 is the unmodified starting point**: stock base images, stock libraries, stock GitHub Actions. Subsequent versions migrate one layer at a time:

| Version | What changes |
|---------|--------------|
| v1      | Baseline — stock everything |
| v2      | Container base images → Chainguard |
| v3      | Application libraries → Chainguard |
| v4      | GitHub Actions → Chainguard |

Each version is intended to ship as a separate branch (or repo) so the migration shows up as a single, reviewable PR.

## Architecture

```
banking-web-ui    → Next.js frontend
banking-worker    → background service (placeholder, to be replaced)
banking-database  → PostgreSQL with schema + seed data
chart             → Helm chart that deploys all of the above
```

## Prerequisites

- [kind](https://kind.sigs.k8s.io/)
- [helm](https://helm.sh/)
- `kubectl`, `docker`
- `chainctl` with access to `chainguard-private` (only needed from v2 onward)

## Demo flow

```bash
# 1. Spin up a local cluster
kind create cluster

# 2. Deploy the vulnerability scanner
./scripts/scanner-deploy.sh

# 3. Build and load images into kind
./scripts/build.sh

# 4. Deploy the application
./scripts/deploy.sh

# 5. Port-forward and use the app
./scripts/port-forward.sh
# → http://localhost:8081
```

Open the scanner dashboard to see the baseline CVE counts, then check out a later branch (`v2`, `v3`, `v4`) and re-run `build.sh` + `deploy.sh` to compare.

## Scripts

All demo helpers live under `scripts/`:

| Script | Purpose |
|--------|---------|
| `build.sh [tag]` | Build all service images and load into kind |
| `deploy.sh [namespace] [tag]` | Helm install/upgrade the chart |
| `port-forward.sh [namespace]` | Forward the web UI to localhost:8081 |
| `scanner-deploy.sh` | Install the vulnerability scanner |
| `teardown.sh [namespace]` | Delete the deployment namespace |

## CI/CD

`.github/workflows/build.yml` builds every service image on each PR.
`.github/workflows/release.yml` publishes images and the Helm chart to GHCR on tag pushes.

The release pipeline exists primarily so that v4 has something to migrate. **The demo never depends on published artifacts** — the demoer always builds fresh against the checked-out branch.
