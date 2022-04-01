#!/usr/bin/env bash
set -xeEuo pipefail
shopt -s nullglob

cd "${BASH_SOURCE[0]%/*}"

q(){
  yq "$@" chart.yaml
}
kustomize build --enable-helm . | kubectl delete --force --wait=false --ignore-not-found -f -
if test "$(hostname)" = "nazarewk-krul"; then
  rm -rf /var/lib/rook
  for device in $(q -r '.valuesInline.cephClusterSpec.storage.devices[].fullpath') ; do
    dd if=/dev/zero of="$device" bs=1M count=10
  done
fi