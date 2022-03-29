#!/usr/bin/env bash
set -xeEuo pipefail

render() {
  # You can use this directly
  kustomize build .
}

is-apply() {
  test "${APPLY:-}" = 1
}

if-apply() {
  if is-apply; then
    "$@"
  fi
}

conditional-apply() {
  if is-apply; then
    kubectl apply -f - "$@"
  else
    cat
    echo "\$APPLY is not set to 1, skipping kubectl apply"
  fi
}
