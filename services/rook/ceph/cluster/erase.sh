#!/usr/bin/env bash
set -xeEuo pipefail
shopt -s nullglob

cd "${BASH_SOURCE[0]%/*}"
rm -rf /var/lib/rook/rook-ceph /var/lib/mon-*