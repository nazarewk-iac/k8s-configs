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
cat <<EOF > patches/limit-cloudflare.yaml
- op: add
  path: "/metadata/annotations/traefik.ingress.kubernetes.io~1whitelist-source-range"
  value: '$(get_ranges | tr '\n' ',' | sed 's/,/, /g')'
EOF
