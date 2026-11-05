# Changelog

## 0.14.0

### Added

- VSA-007 to VSA-010: store shared between contexts, event outbox and consumer idempotency, workflow compensations and timeouts, and events missing from the plan or their contract. They run only when the plan or the code has services, events, or workflows.
- VSA-001 findings for context placement other than `[context]/`, a service spanning contexts or named differently from its context, feature code in `hosts/`, contracts outside `contracts/[contract-name]/[version]/`, folders that code imports but are not `snake_case`, deployed names that are not the kebab-case form of the context and trigger, and slice folders that break the naming rules.
- VSA-007 and VSA-010 also check each context's `manifest`. VSA-010 also checks that events are named in the past tense.
- A preset version check: the review reports `NOT RUN` unless vertical-slice 0.20.x is active.
- `repository` field, `LICENSE`, and this changelog.

### Changed

- Exceptions match rows in the plan's Slice Rule Exceptions table instead of Complexity Tracking.
- VSA-001 guidance is split into one bullet per finding, with unchanged wording.
- The README lists only rule IDs, names, and severities. The command file is the single source of rule wording.

## 0.13.0

- Previous release.
