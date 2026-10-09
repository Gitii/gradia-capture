#!/bin/bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

base=''
while IFS= read -r line; do
    if [[ "$line" == Version:* ]]; then
        base="${line#Version: }"
    fi
done < packaging/control
[[ "$base" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]

ref="${GITHUB_REF:-$(git symbolic-ref -q HEAD || true)}"
sha="${GITHUB_SHA:-$(git rev-parse HEAD)}"
if [[ "$ref" == refs/tags/v* ]]; then
    tag="${ref#refs/tags/v}"
    if [[ "$tag" != "$base" ]]; then
        printf 'Tag v%s does not match packaging/control version %s\n' "$tag" "$base" >&2
        exit 1
    fi
    printf '%s~ubuntu24.04-1\n' "$base"
else
    printf '%s~git%s.%s~ubuntu24.04-1\n' "$base" "$(date -u +%Y%m%d%H%M%S)" "${sha:0:7}"
fi
