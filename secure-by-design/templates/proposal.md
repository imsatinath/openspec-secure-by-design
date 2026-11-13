# Proposal

## Why

<!-- Explain the motivation for this change. What problem does this solve? Why now? -->

## What Changes

<!-- Describe what will change. Be specific about new capabilities, modifications, or removals. -->

## Capabilities

### New Capabilities
<!-- Capabilities being introduced. Name each capability for a cohesive system
     behavior that can own related requirements as the system evolves. Do not name
     implementation tasks or proposal sections. Avoid broad catch-all names. Use
     kebab-case for path segments you introduce (e.g., user-auth or identity/user-auth)
     that follow the project's existing spec organization. Each creates
     specs/<capability-path>/spec.md. -->
- `<capability-path>`: <brief description of what this capability covers>

### Modified Capabilities
<!-- Existing capabilities whose REQUIREMENTS are changing (not just implementation).
     Only list here if spec-level behavior changes. Each needs a delta spec file.
     Use the exact existing path under openspec/specs/. Leave empty if no requirement
     changes. A change with no capabilities at all (pure refactor, tooling, docs)
     must set `skip_specs: true` in its .openspec.yaml - openspec validate rejects
     a zero-delta change without that marker. Do not invent a requirement just to
     satisfy validation. -->
- `<existing-capability-path>`: <what requirement is changing>

## Impact

<!-- Affected code, APIs, dependencies, systems -->

## Security Impact Screen

**Initial risk tier:** <!-- LOW | STANDARD | HIGH -->

<!-- Answer each item with Yes, No, or Unknown and a short reason. Unknowns must be resolved before tasks. -->

| Security trigger | Answer | Reason |
|---|---|---|
| Authentication or authorization behavior changes |  |  |
| Sensitive, regulated, or personal data is introduced or rerouted |  |  |
| A trust boundary, external input, API, webhook, or integration changes |  |  |
| Secrets, cryptography, signing, or key management changes |  |  |
| A dependency, build pipeline, container, IaC, or deployment boundary changes |  |  |
| Abuse could cause financial, safety, availability, or privacy impact |  |  |

### Risk Tier Guidance

- **LOW**: No new trust boundary, privilege, sensitive-data flow, external input, runtime dependency, deployment surface, or meaningful abuse impact.
- **STANDARD**: An ordinary application change with a security-relevant input, data flow, dependency, integration, or user-visible behavior.
- **HIGH**: Authentication, authorization, secrets, cryptography, sensitive or regulated data, tenant isolation, infrastructure boundaries, or material financial, safety, privacy, or availability impact.

