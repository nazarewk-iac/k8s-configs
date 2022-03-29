#!/usr/bin/env bash
set -eEuo pipefail
set -x
cd "${BASH_SOURCE[0]%/*}"


istioctl manifest generate -f ./config.yaml -o ./generated
