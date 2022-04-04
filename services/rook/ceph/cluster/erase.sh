#!/usr/bin/env bash
set -xeEuo pipefail
shopt -s nullglob

cd "${BASH_SOURCE[0]%/*}"

q(){
  yq "$@" chart.yaml
}
kustomize build --enable-helm . | kubectl delete --force --wait=false --ignore-not-found -f -
blockpools=(
  $(kubectl get -n rook-ceph cephblockpools.ceph.rook.io -o name)
)
if test "${#blockpools[@]}" -gt 0 ; then
  kubectl patch -n rook-ceph "${blockpools[@]}" --type=merge --patch='{"metadata":{"finalizers":[]}}'
fi
if test "$(hostname)" = "nazarewk-krul"; then
  rm -rf "$(q -r '.valuesInline.cephClusterSpec.dataDirHostPath')"
  for device in $(q -r '.valuesInline.cephClusterSpec.storage.devices[].fullpath') ; do
    ceph-volume lvm zap "$device"
  done
fi
