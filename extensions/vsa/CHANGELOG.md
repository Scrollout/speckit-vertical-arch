# Changelog

## 0.19.0

### Added

- VSA-014 judges every test change, source change, Red point, and verdict against the implement rules' Changing tests. It pairs tests across moves, judges each entry on its own change, diffs or hashes each test and source against its baseline, compares the tests the test command selects now and at the merge base, checks each entry's commit, reports due tests without a task (after tasks) or an entry (after implement), test changes after a standing verdict, skips added to an existing test, same-session entries no fresh agent has judged, and code that behaves differently under test, applies each `fails on` edit or a targeted change of its own, and lists work from before adoption. No exception accepts it.
- The report gains a **Test changes** line. The scope includes `spec.md` and every feature's `test-ledger/` folder.

### Changed

- The command's read-only rule applies to the project's working tree; the reviewer may still run and edit code in its own copy.
- VSA-012 covers checks, thresholds, and report rules, and the checks the test command runs; test changes, and how the test command runs and selects tests, moved to VSA-014.
- Supports vertical-slice 0.25.x.

## 0.18.0

### Changed

- The feature directory comes from the prompt when it names one, before `.specify/feature.json`, so a fresh reviewer whose copy lacks that file is not reported `NOT RUN`.
- The fresh reviewer's copy includes the default branch and the working tree's uncommitted changes, including untracked files, when git is available.
- VSA-002 does not flag the position of an `#### Open items` group, nor a test task there that follows its slice's implementation; the group's tasks are ordered among themselves.
- A re-run checks that each previous warning now has a home in `tasks.md`, and reports one with no home again as a warning under its own rule.
- A `WARN` report's next step tells the developer to record each warning as a task in an `#### Open items` group of its phase, or why it is closed.
- Supports vertical-slice 0.24.x.

## 0.17.0

### Added

- VSA-001 flags a program that runs its slices from a hand-kept list, unless the list is generated from the folders or the test command compares it with them.
- VSA-001 flags a consumer slice whose `entry` does not declare its queue or subscription and its event keys.
- VSA-001 flags contract source outside a slice's `contract` file and `contracts/`, and contract source in a version folder.
- VSA-001 flags a schema change outside the one ordered migration history, or a migration that does not name its slice, when the store uses migrations.
- VSA-006 flags a missing or passing drift check when a context writes its contracts in a source language.

### Changed

- VSA-001 does not flag a slice's `contract` file, or shared contract source and compiler settings beside the version folders.
- VSA-005 accepts a consumer slice's queue and event keys named once in its `entry` with a test, and flags broker or queue configuration in the repository that no test checks.
- VSA-010 compares broker or queue configuration in the repository with what the consumer slices declare.
- A fresh reviewer that runs a tool that writes works in its own copy of the repository, in a folder of its own.
- Supports vertical-slice 0.23.x.

## 0.16.0

### Added

- VSA-013: guarded state changed by a slice without going through its owner, or two owners' state changed in one transaction.

### Changed

- VSA-004 also warns about a value rule checked outside its domain type, checked in more than one place, or with no type that enforces it.
- VSA-012 also compares each slice's tests with its Red point.
- VSA-011 uses the 90% confidence threshold, raised from 85%.
- Supports vertical-slice 0.22.x.

## 0.15.0

### Added

- VSA-002 also flags a slice's implementation before its contract or failing tests, and contracts, store schema, or shared models built ahead of the slice that needs them.

- Reviewer order: a fresh sub-agent with no prior context when available, otherwise the same session, recorded on the **Reviewer** line. The user is never asked to run anything.
- The review finds evidence by progressive distributed disclosure, and every rule that holds says why.
- VSA-011: work acting on an open, low-confidence, or unsourced decision.
- VSA-012: a check, threshold, test expectation, or report rule weakened without a recorded reason.
- VSA-006 also covers hand-kept target lists, missing coverage counts, missing planted-violation or clean tests, and an unenforced retired-terms file.

### Changed

- A re-run receives the previous report, verifies its findings first, and then reviews only what changed.
- VSA-009 requires a named pivot and compensations only for steps before it.
- VSA-002 does not flag a Shared group directly before its first slice, or outbox and inbox setup in Foundational.

- The report header is exactly `## VSA Check: <STATUS>`; re-runs go on a **Run** line. Finding columns are Rule, Severity, Location, Evidence, Detail.
- Supports vertical-slice 0.21.x.

## 0.14.0

### Added

- VSA-007 to VSA-010: store shared between contexts, event outbox and consumer idempotency, workflow compensations and timeouts, and events missing from the plan or their contract. They run only when the plan or the code has services, events, or workflows.
- VSA-001 findings for context placement other than `[context]/`, a service spanning contexts or named differently from its context, feature code in `hosts/`, contracts outside `contracts/[contract-name]/[version]/`, folders that code imports but are not `snake_case`, deployed names that are not the kebab-case form of the context and trigger, and slice folders that break the naming rules.
- VSA-001 also flags a slice with both sides whose tests are not split, backend files named for no role or sharing a file they must not, a slice frontend calling another context outside its contract, frontend browser names without the context prefix, per-event AsyncAPI documents, deployed names over 63 characters or not starting with a letter, and a manifest that lists programs.
- VSA-008 also requires a named relay, and an inbox record in the same transaction as the consumer's state change.
- Rule wording uses `entrypoints/`, `backend/`, and `frontend/`.
- VSA-007 and VSA-010 also check each context's `manifest`. VSA-010 also checks that events are named in the past tense.
- A preset version check: the review reports `NOT RUN` unless vertical-slice 0.20.x is active.
- `repository` field, `LICENSE`, and this changelog.

### Changed

- VSA-009 also checks the timeout's recorded deadline, that the timeout slice finds overdue records through it, and that a second run changes nothing.
- VSA-005 states when event type names and handler keys in code are allowed: named once and proven equal to the manifest by a test.

- The report's first column is the rule ID (`VSA-00N`), one row per finding, replacing an ambiguous ID column.
- VSA-004 does not report similar data access in two slices' repositories, only a duplicated rule that decides correctness.

- Exceptions match rows in the plan's Slice Rule Exceptions table instead of Complexity Tracking.
- VSA-001 guidance is split into one bullet per finding, with unchanged wording.
- The README lists only rule IDs, names, and severities. The command file is the single source of rule wording.

## 0.13.0

- Previous release.
