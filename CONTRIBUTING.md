# Contributing

Thank you for improving `secure-by-design`.

## Development requirements

- OpenSpec 1.16.0 or newer
- A POSIX shell

Run both checks before opening a pull request:

```bash
sh scripts/validate-bundle.sh
sh tests/test-bundle.sh
sh tests/test-upstream-defaults.sh
sh tests/test-lifecycle.sh
```

## Design rules

1. Keep `specs/**/*.md` compatible with OpenSpec's standard delta format. Security requirements belong in specs; scanner output does not.
2. Treat scanner output as evidence, not as the sole verdict. Findings need applicability and traceability review.
3. Treat failed, skipped-without-reason, malformed, or unavailable required checks as incomplete.
4. Preserve stable IDs (`THR-*`, `MIT-*`, `CHK-*`, `FND-*`) within a change.
5. Put project-specific commands in `openspec/security-checks.yaml`, not in the reusable schema.
6. Keep raw reports out of Markdown when they may contain secrets, source excerpts, personal data, or attack payloads.
7. Require a named human owner for accepted residual risk. An agent may recommend a disposition but may not impersonate the accepting authority.
8. Preserve the upstream defaults according to `UPSTREAM.md`; extend them additively.

## Schema graph changes

Changing an artifact ID, output path, `requires` edge, or apply prerequisite can invalidate in-flight changes. Include a migration note and increment the major schema version when making one of these changes.

