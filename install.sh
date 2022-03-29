#!/usr/bin/env bash
set -xeEuo pipefail

cd "${BASH_SOURCE[0]%/*}"

services=("$@")

if test "${#services[@]}" = 0 ; then
  services=(
    services/reloader
    services/istio
    argocd
  )
fi

for service in "${services[@]}" ; do
  "./${service}/install.sh"
done
