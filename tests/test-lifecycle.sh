#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/openspec-secure-lifecycle.XXXXXX")
cleanup() {
  rm -rf -- "$tmp_dir"
}
trap cleanup EXIT HUP INT TERM

openspec init "$tmp_dir" --tools none --no-animation --no-copilot-cloud >/dev/null
mkdir -p "$tmp_dir/openspec/schemas"
cp -R "$repo_dir/secure-by-design" "$tmp_dir/openspec/schemas/secure-by-design"

assert_status() {
  artifact=$1
  expected=$2
  node -e '
    const fs = require("fs");
    const data = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
    const artifact = data.artifacts.find((item) => item.id === process.argv[2]);
    if (!artifact || artifact.status !== process.argv[3]) {
      console.error(`expected ${process.argv[2]}=${process.argv[3]}, got ${artifact?.status ?? "missing"}`);
      process.exit(1);
    }
  ' status.json "$artifact" "$expected"
}

(
  cd "$tmp_dir"
  openspec new change lifecycle-smoke --schema secure-by-design >/dev/null
  openspec status --change lifecycle-smoke --json > status.json
  openspec instructions proposal --change lifecycle-smoke --json > proposal.json

  grep -q '"schemaName": "secure-by-design"' status.json
  grep -q 'Security Impact Screen' proposal.json

  assert_status proposal ready
  assert_status specs blocked
  assert_status design blocked

  change_dir=openspec/changes/lifecycle-smoke
  cp "$repo_dir/secure-by-design/templates/proposal.md" "$change_dir/proposal.md"
  openspec status --change lifecycle-smoke --json > status.json
  assert_status specs ready
  assert_status design ready
  assert_status threat-model blocked

  mkdir -p "$change_dir/specs/example"
  cp "$repo_dir/secure-by-design/templates/spec.md" "$change_dir/specs/example/spec.md"
  cp "$repo_dir/secure-by-design/templates/design.md" "$change_dir/design.md"
  openspec status --change lifecycle-smoke --json > status.json
  assert_status threat-model ready

  cp "$repo_dir/secure-by-design/templates/threat-model.md" "$change_dir/threat-model.md"
  openspec status --change lifecycle-smoke --json > status.json
  assert_status security-plan ready

  cp "$repo_dir/secure-by-design/templates/security-plan.md" "$change_dir/security-plan.md"
  openspec status --change lifecycle-smoke --json > status.json
  assert_status tasks ready

  cp "$repo_dir/secure-by-design/templates/tasks.md" "$change_dir/tasks.md"
  openspec status --change lifecycle-smoke --json > status.json
  assert_status verify ready
  assert_status security-assurance blocked

  cp "$repo_dir/secure-by-design/templates/verify.md" "$change_dir/verify.md"
  openspec status --change lifecycle-smoke --json > status.json
  assert_status security-assurance ready

  openspec instructions security-assurance --change lifecycle-smoke --json > assurance.json
  grep -q 'Emit exactly one top-level verdict' assurance.json
)

echo "lifecycle smoke test passed"

