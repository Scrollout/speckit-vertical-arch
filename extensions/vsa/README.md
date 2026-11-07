# Vertical Slice Check Extension

Adds `speckit.vsa.check`, which checks a feature's artifacts and code against the vertical slice rules. It changes nothing.

## Requirements

- Spec-Kit 1.2.5 or later.
- The `vertical-slice` preset, version 0.22.x. An extension manifest cannot require a preset, so the check tests for it when it runs and reports `NOT RUN` if it's missing, disabled, or a different version.

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
| VSA-001 | Project Structure, context placement, slice roles, contract layout, and folder, service, and frontend naming | Blocking |
| VSA-002 | Task order: layers, or code before its contract and failing tests | Blocking |
| VSA-003 | Hidden reach between slices or contexts | Blocking |
| VSA-004 | Duplicated domain rules, and value rules checked outside their domain type | Warning |
| VSA-005 | Values outside their home | Blocking |
| VSA-006 | Test command, boundary check, and contract checks | Blocking |
| VSA-007 | Store shared between contexts | Blocking |
| VSA-008 | Event outbox, relay, and consumer idempotency in one transaction | Blocking |
| VSA-009 | Workflow compensations and timeouts | Blocking |
| VSA-010 | Events missing from the plan, their contract, or a manifest, and event naming | Blocking |
| VSA-011 | Work acting on an open, low-confidence, or unsourced decision | Blocking |
| VSA-012 | A check, threshold, or test expectation weakened since the merge base or a slice's Red point, without a recorded reason | Blocking |
| VSA-013 | Guarded state changed around its owner, or two owners changed in one transaction | Blocking |

VSA-007 to VSA-010 run only when the plan or the code has services, events, or workflows.

## Reviewer

The check runs in a fresh sub-agent with no prior context when the agent supports one, so the author does not review its own work. Otherwise it reports `Reviewer: same session (fresh review NOT RUN: no sub-agent support)` and runs in the current session. It never asks the user to run anything.

## Results

| Status | Meaning |
|---|---|
| `FAIL` | A blocking finding has no recorded exception. Fix it or record one before continuing |
| `WARN` | Only warnings. Work may continue |
| `PASS` | No unaccepted findings in what was examined |
| `NOT RUN` | The preset or the current feature is missing. This is never a pass |

The check reviews only the current feature's artifacts and the code it adds or changes.

## Limits

- Blocking tells the developer to stop, but it cannot prevent someone continuing by hand.
- The check is agent-driven, so results can vary between runs, and it cannot prove that no duplication exists.
- It doesn't replace language-specific boundary tooling, which belongs in the project's test command. It checks that the test command runs the boundary check and every context's tests.

To accept an exception, add a row to the plan's Slice Rule Exceptions table naming the rule, the location, and the reason.
