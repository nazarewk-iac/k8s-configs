#!/usr/bin/env bash
set -eEuo pipefail
set -x
cd "${BASH_SOURCE[0]%/*}"

istioctl verify-install -f config.yaml
