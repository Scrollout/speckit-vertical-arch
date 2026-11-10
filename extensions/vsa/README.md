# Vertical Slice Check Extension

Adds `speckit.vsa.check`, which checks a feature's artifacts and code against the vertical slice rules. It changes nothing.

## Requirements

- Spec-Kit 1.2.5 or later.
- The `vertical-slice` preset, version 0.25.x. An extension manifest cannot require a preset, so the check tests for it when it runs and reports `NOT RUN` if it's missing, disabled, or a different version.

## Install and remove

```bash
specify extension add --dev <path-to-this-folder>
specify extension remove vsa
```

## When it runs

- Automatically after `/speckit-tasks` and `/speckit-implement`.
- On demand with `/speckit-vsa-check`.

## Rules

The full wording of each rule lives in [`commands/speckit.vsa.check.md`](commands/speckit.vsa.check.md), which is the single source. This list is only an index.

| Rule | Checks | Severity |
|---|---|---|
| VSA-001 | Project Structure, context placement, slice roles, contract layout, slice discovery, migrations, and folder, service, and frontend naming | Blocking |
| VSA-002 | Task order: layers, or code before its contract and failing tests | Blocking |
| VSA-003 | Hidden reach between slices or contexts | Blocking |
| VSA-004 | Duplicated domain rules, and value rules checked outside their domain type | Warning |
| VSA-005 | Values outside their home | Blocking |
| VSA-006 | Test command, boundary check, contract checks, and contract drift | Blocking |
| VSA-007 | Store shared between contexts | Blocking |
| VSA-008 | Event outbox, relay, and consumer idempotency in one transaction | Blocking |
| VSA-009 | Workflow compensations and timeouts | Blocking |
| VSA-010 | Events missing from the plan, their contract, or a manifest, and event naming | Blocking |
| VSA-011 | Work acting on an open, low-confidence, or unsourced decision | Blocking |
| VSA-012 | A check, threshold, or report rule weakened since the merge base, without a recorded reason | Blocking |
| VSA-013 | Guarded state changed around its owner, or two owners changed in one transaction | Blocking |
| VSA-014 | A test change, source change, Red point, or verdict that breaks the constitution's Tests change through the ledger, a test change with no ledger entry, a due test with no later entry, or code that behaves differently under test | Blocking |

VSA-007 to VSA-010 run only when the plan or the code has services, events, or workflows.

## Reviewer

The check runs in a fresh sub-agent with no prior context when the agent supports one, so the author does not review its own work. Anything it runs that writes, it runs in its own copy of the repository, in a folder of its own, which includes the default branch and uncommitted changes, including untracked files, when git is available, and its brief names the feature directory. Otherwise it reports `Reviewer: same session (fresh review NOT RUN: no sub-agent support)` and runs in the current session. It never asks the user to run anything.

## Results

| Status | Meaning |
|---|---|
| `FAIL` | A blocking finding has no recorded exception. Fix it or record one before continuing |
| `WARN` | Only warnings. Work may continue; give each warning a home in `tasks.md` |
| `PASS` | No unaccepted findings in what was examined |
| `NOT RUN` | The preset or the current feature is missing. This is never a pass |

The check reviews only the current feature's artifacts and the code it adds or changes.

## Limits

- Blocking tells the developer to stop, but it cannot prevent someone continuing by hand.
- The check is agent-driven, so results can vary between runs, and it cannot prove that no duplication exists.
- `/speckit-tasks` and `/speckit-implement` re-run the check only after a blocking finding, so a result with only warnings is not checked again. A later run has no previous report, so it does not check homes; it reports a warning again only when its cause is still in scope.
- VSA-014 finds what changed mechanically, from diffs, hashes, rename detection, and the tests the test command selects, and proves failure by applying a targeted change, but whether an edit changes what a test checks is judged. Whether a source change was made through the step that owns it is judged too, since a hand edit and a `/speckit-clarify` edit look alike. It cannot prove who wrote a ledger entry or that no fresh agent was available, or that a spec change came from the user, and an entry discarded before it is committed leaves no trace. Without git, a changed test is judged whole against its sources, and a test no entry lists has no baseline.
- The checks' planted-violation and clean tests sit under Fix the cause and VSA-012, not under Tests change through the ledger, so a Slice Rule Exceptions row can accept a change to them.
- It doesn't replace language-specific boundary tooling, which belongs in the project's test command. It checks that the test command runs the boundary check and every context's tests.

To accept an exception, add a row to the plan's Slice Rule Exceptions table naming the rule, the location, and the reason. No row accepts VSA-014: ledger entries are records, not exceptions.
