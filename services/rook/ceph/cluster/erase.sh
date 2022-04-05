#!/usr/bin/env bash
set -xeEuo pipefail
shopt -s nullglob

cd "${BASH_SOURCE[0]%/*}"

kustomize build --enable-helm . | kubectl delete --force --wait=false --ignore-not-found -f -

blockpools=(
  $(kubectl get -n rook-ceph cephblockpools.ceph.rook.io -o name)
)
if test "${#blockpools[@]}" -gt 0 ; then
  kubectl patch -n rook-ceph "${blockpools[@]}" --type=merge --patch='{"metadata":{"finalizers":[]}}'
fi
if test "$(hostname)" = "nazarewk-krul"; then
  for disk in /dev/disk/by-id/dm-name-rook-ceph-* ; do
    cryptsetup close "${disk}"
  done
  sync
  rm -rf "$(yq -r '.valuesInline.cephClusterSpec.dataDirHostPath' chart.yaml)"
  ceph-volume lvm zap $(yq -r '.spec.local.path | select(.)' pvs.yaml)
fi
