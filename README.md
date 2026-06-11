# Chainguard Demo
A demo showing the value of securing your applicaiton using Chainguard.

This demo takes an application through a hardening process using the following technologies from Chainguard:
* Chainguard Containers
* Chainguard Libraries
* Chainguard Actions

## Quick demo proof points
The implementation of each technology is captured in a pull request as follows:
* Chainguard Containers: https://github.com/bvboe/chainguard-demo/pull/10
* Chainguard Libraries: https://github.com/bvboe/chainguard-demo/pull/11
* Chainguard Actions: https://github.com/bvboe/chainguard-demo/pull/12

## Demo Pre-Requisites
* kind - https://kind.sigs.k8s.io/
* chainctl with access to Chainguard Libraries

## Demo Preparations
Setup Kubernetes cluster
```
kind create cluster
```
Download each release of the demo into separate directories
```
git clone --branch v1.0.0 --single-branch https://github.com/bvboe/chainguard-demo v1
git clone --branch v2.0.0 --single-branch https://github.com/bvboe/chainguard-demo v2
git clone --branch v3.0.0 --single-branch https://github.com/bvboe/chainguard-demo v3
git clone --branch v4.0.0 --single-branch https://github.com/bvboe/chainguard-demo v4
```
Generate Chainguar Libraries tokens and put them in environment variables:
```
ORG=<Your-Chainguard-Organization>
NPM=$(chainctl auth pull-token create --repository=javascript --parent=$ORG --name="cg-demo" -o json)
export CG_NPM_USER=$(echo "$NPM" | jq -r .identity_id)
export CG_NPM_PASS=$(echo "$NPM" | jq -r .token)

PYPI=$(chainctl auth pull-token create --repository=python --parent=$ORG --name="cg-demo" -o json)
export CG_PYPI_USER=$(echo "$PYPI" | jq -r .identity_id)
export CG_PYPI_PASS=$(echo "$PYPI" | jq -r .token)
```
Build containers for all versions
```
./v1/scripts/build.sh
./v2/scripts/build.sh
./v3/scripts/build.sh
./v4/scripts/build.sh
```
## Demo Flow
### Setup Initial Application
Install container scanner and version 1 of demo application on Kind cluster.
```
./v1/scripts/deploy-scanner.sh
./v1/scripts/deploy-demo.sh
```
Setup port forwarding to test application in separate window. This connection may go down later when redeploying the application. If that happens, just restart the port forward.
```
./v1/scripts/port-forward-demo.sh
```
Test the application on http://localhost:8080/.
<img width="1432" height="975" alt="image" src="https://github.com/user-attachments/assets/f4403130-4702-401e-9c0b-c98e4b11a754" />
Setup port forwarding to Kubernetes vulnearbility scanner.
```
./v1/scripts/port-forward-scanner.sh
```
Review the scan results for the demo application at http://localhost:8081/pods.html?namespaces=banking-demo.
<img width="1270" height="797" alt="image" src="https://github.com/user-attachments/assets/ac50d80a-c406-40bd-a503-3d219ae4784b" />
We can see 3 containers running with a total of over 2,000 CVEs.

### Migrate to Chainguard Containers
We already have a version 2 of the application that has been migrated to Chainguard Containers. Review the pull request at https://github.com/bvboe/chainguard-demo/pull/10 for more details on how this migration was done.

Upgrade our running application to version 2.
```
./v2/scripts/deploy-demo.sh
```

Revisit the scanner UI at http://localhost:8081/pods.html?namespaces=banking-demo and see that the total number of vulnearabilities have been reduced to 5.
<img width="1270" height="797" alt="image" src="https://github.com/user-attachments/assets/7eb062a6-c880-4190-965a-e1b96ece837b" />

### Migrate to Chainguard Libraries
We already have a version 3 of the application that has been migrated to Chainguard Libraries. Review the pull request at https://github.com/bvboe/chainguard-demo/pull/11 for more details on how this migration was done.

Upgrade our running application to version 3.
```
./v3/scripts/deploy-demo.sh
```

Validate that the new images are built using Chainguard Libraries
```
chainctl libraries verify --detailed banking-worker:3.0.0
chainctl libraries verify --detailed banking-web-ui:3.0.0
```

### Migrate to Chainguard Actions
We already have a version 4 of the application that has been migrated to Chainguard Libraries. Review the pull request at https://github.com/bvboe/chainguard-demo/pull/12 for more details on how this migration was done.
