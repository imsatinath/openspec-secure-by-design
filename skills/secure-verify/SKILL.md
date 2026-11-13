---
name: secure-verify
description: Verify an implemented OpenSpec secure-by-design change when the user asks for security verification, vulnerability checks, mitigation evidence, scanner triage, or an assurance verdict.
---

# Secure verification

Produce an evidence-backed `security-assurance.md` for an implemented change. The
OpenSpec schema is the source of truth for policy and artifact instructions.

## Steps

1. Resolve the change.
   - Use the change named by the user.
   - If no name is supplied, run `openspec status --all --json` and select only
     when exactly one active `secure-by-design` change is unambiguous. Otherwise,
     ask for the change name.
   - Completion: one active change and its planning root are identified.

2. Load current instructions.
   - Run `openspec status --change <name> --json`.
   - Run `openspec instructions apply --change <name> --json` and read its context
     and operation guidance.
   - Run `openspec instructions verify --change <name> --json` and
     `openspec instructions security-assurance --change <name> --json`.
   - Completion: current schema instructions, project context, artifact paths,
     and readiness are known from command output rather than assumed.

3. Establish the authorized check set.
   - Read proposal.md, specs, design.md, threat-model.md, security-plan.md,
     tasks.md, and `openspec/security-checks.yaml` when present.
   - Inspect each configured command and report path. Ask for authorization when
     execution, installation, network access, or target interaction requires it.
   - Treat an absent optional check as NOT_APPLICABLE only with a reason. Treat an
     absent required check as INCOMPLETE.
   - Completion: every planned check is classified as runnable, already evidenced,
     not applicable with reason, or incomplete with reason.

4. Collect evidence.
   - Run only authorized checks, preserving exit status and report path.
   - Inspect existing reports without copying secrets, personal data, raw attack
     payloads, or unnecessary source excerpts into Markdown.
   - A crash, timeout, missing executable, malformed report, or policy-disallowed
     stale database is INCOMPLETE rather than clean.
   - Completion: every applicable check has inspectable evidence or an explicit
     incomplete state.

5. Verify and triage.
   - Follow the loaded verify instructions to create or refresh verify.md.
   - Follow the loaded security-assurance instructions exactly.
   - Normalize findings as FND-* records, retain source IDs, deduplicate only with
     same-root-cause evidence, and map each finding to a threat/mitigation or a
     newly discovered risk.
   - An agent can recommend an exception but cannot act as the human risk owner.
   - Completion: every required check, threat, mitigation, blocking finding, and
     exception is accounted for.

6. Emit the verdict and handoff.
   - Write exactly one `VERDICT: PASS|CONDITIONAL|FAIL` line in
     security-assurance.md according to the loaded policy.
   - Report check coverage, blocking findings, protected report paths, residual
     risks, and the next permitted action.
   - Archive only when separately requested and the verdict/policy allows it.
   - Completion: the verdict follows from cited evidence and no required state is
     silently treated as successful.

