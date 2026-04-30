helm upgrade --install bjorn2scan oci://ghcr.io/bvboe/b2s-go/bjorn2scan \
    --namespace b2sv2 \
    --create-namespace \
    --set clusterName="Kubernetes"
