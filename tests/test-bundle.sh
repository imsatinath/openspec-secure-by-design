#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
schema="$repo_dir/secure-by-design/schema.yaml"

required_templates="proposal spec design threat-model security-plan tasks verify security-assurance"
for template in $required_templates; do
  test -f "$repo_dir/secure-by-design/templates/$template.md" || {
    echo "missing template: $template.md" >&2
    exit 1
  }
done

for artifact in proposal specs design threat-model security-plan tasks verify security-assurance; do
  grep -q "^  - id: $artifact$" "$schema" || {
    echo "missing artifact: $artifact" >&2
    exit 1
  }
done

grep -q '^apply:$' "$schema"
grep -q '^  requires: \[tasks\]$' "$schema"
grep -q '^  tracks: tasks.md$' "$schema"
grep -q '^VERDICT: <!-- PASS | CONDITIONAL | FAIL -->$' \
  "$repo_dir/secure-by-design/templates/security-assurance.md"
grep -q 'incomplete_required_check: fail' \
  "$repo_dir/config/security-checks.example.yaml"

echo "bundle contract checks passed"

