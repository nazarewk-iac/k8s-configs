#!/usr/bin/env bash
cd "${BASH_SOURCE[0]%/*}" || exit 1
source "$(git rev-parse --show-toplevel)/lib.sh"

render | conditional-apply
