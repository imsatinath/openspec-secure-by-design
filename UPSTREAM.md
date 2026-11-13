# Upstream baseline

This schema extends the bundled `spec-driven` schema from OpenSpec 1.16.0.

The following compatibility rules are intentional and tested:

- `secure-by-design/templates/spec.md` is byte-for-byte identical to the upstream template.
- The upstream `proposal.md`, `design.md`, and `tasks.md` files are exact prefixes of the corresponding secure-by-design templates. Security sections are appended after the complete upstream content.
- The upstream proposal, specs, design, and tasks instruction blocks are exact prefixes of the corresponding secure-by-design instruction blocks. Security guidance is appended after the upstream instructions.
- The default artifact IDs, filenames, OpenSpec delta format, task checkbox format, and apply tracking behavior are retained.
- New security artifacts and the `security-plan` dependency are additions to the default graph.

When upgrading the OpenSpec baseline, update this file, run the full test suite, inspect the upstream diff, and document any graph migration required for in-flight changes.

