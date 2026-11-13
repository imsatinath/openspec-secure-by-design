#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

if ! command -v openspec >/dev/null 2>&1; then
  echo "openspec is required (tested with 1.16.0+)" >&2
  exit 127
fi

tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/openspec-secure-by-design.XXXXXX")
cleanup() {
  rm -rf -- "$tmp_dir"
}
trap cleanup EXIT HUP INT TERM

openspec init "$tmp_dir" --tools none --no-animation --no-copilot-cloud >/dev/null
mkdir -p "$tmp_dir/openspec/schemas"
cp -R "$repo_dir/secure-by-design" "$tmp_dir/openspec/schemas/secure-by-design"

(
  cd "$tmp_dir"
  openspec schema validate secure-by-design
)

