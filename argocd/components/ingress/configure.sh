#!/usr/bin/env bash
set -eEuo pipefail
set -x
cd "${BASH_SOURCE[0]%/*}"

get_ranges() {
  {
    curl -sf -L 'https://www.cloudflare.com/ips-v4'
    curl -sf -L 'https://www.cloudflare.com/ips-v6'
  } | sort | uniq | head -c-1
}
cat <<EOF > limit-cloudflare.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server
  annotations:
    traefik.ingress.kubernetes.io/whitelist-source-range: '$(get_ranges | tr '\n' ',' | sed 's/,/, /g')'
EOF
