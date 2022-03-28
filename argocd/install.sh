#!/usr/bin/env bash
set -xeEuo pipefail

cd "${BASH_SOURCE[0]%/*}"
service_name="${PWD##*/}"

render() {
  # You can use this directly
  kustomize build --enable-helm .
}

render | if [ "${APPLY:-}" = 1 ]; then
  kubectl apply --context infrastructure-01 -n "${service_name}" -f -
else
  cat
  echo "\$APPLY is not set to 1, skipping kubectl apply"
fi
