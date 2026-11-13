#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
upstream_dir=$(openspec schema which spec-driven 2>/dev/null | awk '/^Path: / { sub(/^Path: /, ""); print; exit }')

if test -z "$upstream_dir" || test ! -d "$upstream_dir"; then
  echo "unable to resolve bundled spec-driven schema" >&2
  exit 1
fi

assert_exact() {
  upstream=$1
  extended=$2
  cmp -s "$upstream" "$extended" || {
    echo "$extended must exactly match $upstream" >&2
    exit 1
  }
}

assert_prefix() {
  upstream=$1
  extended=$2
  line_count=$(wc -l < "$upstream" | tr -d ' ')
  head -n "$line_count" "$extended" | cmp -s - "$upstream" || {
    echo "$extended must retain $upstream as an exact prefix" >&2
    exit 1
  }
}

extract_instruction() {
  schema=$1
  artifact=$2
  destination=$3
  awk -v artifact="$artifact" '
    $0 == "  - id: " artifact { in_artifact = 1; next }
    in_artifact && (/^  - id: / || /^apply:/) { exit }
    in_artifact && /^    instruction: \|/ { in_instruction = 1; next }
    in_instruction && /^    requires:/ { exit }
    in_instruction { print }
  ' "$schema" > "$destination"
}

assert_exact \
  "$upstream_dir/templates/spec.md" \
  "$repo_dir/secure-by-design/templates/spec.md"

for template in proposal design tasks; do
  assert_prefix \
    "$upstream_dir/templates/$template.md" \
    "$repo_dir/secure-by-design/templates/$template.md"
done

tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/openspec-defaults.XXXXXX")
cleanup() {
  rm -rf -- "$tmp_dir"
}
trap cleanup EXIT HUP INT TERM

for artifact in proposal specs design tasks; do
  extract_instruction "$upstream_dir/schema.yaml" "$artifact" "$tmp_dir/upstream-$artifact"
  extract_instruction "$repo_dir/secure-by-design/schema.yaml" "$artifact" "$tmp_dir/extended-$artifact"
  assert_prefix "$tmp_dir/upstream-$artifact" "$tmp_dir/extended-$artifact"
done

echo "upstream default retention checks passed"

