# Vertical Slice Check Extension

Adds `speckit.vsa.check`, which checks a feature's artifacts and code against the vertical slice rules. It changes nothing.

## Requirements

- Spec-Kit 1.2.5 or later.
- The `vertical-slice` preset, version 0.20.x. An extension manifest cannot require a preset, so the check tests for it when it runs and reports `NOT RUN` if it's missing, disabled, or a different version.

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
| VSA-001 | Project Structure, context placement, and slice naming | Blocking |
| VSA-002 | Task order by technical layer | Blocking |
| VSA-003 | Hidden reach between slices or contexts | Blocking |
| VSA-004 | Duplicated domain rules | Warning |
| VSA-005 | Values outside their home | Blocking |
| VSA-006 | Test command, boundary check, and contract checks | Blocking |
| VSA-007 | Store shared between contexts | Blocking |
| VSA-008 | Event outbox and consumer idempotency | Blocking |
| VSA-009 | Workflow compensations and timeouts | Blocking |
| VSA-010 | Events missing from the plan, their contract, or a manifest, and event naming | Blocking |

VSA-007 to VSA-010 run only when the plan or the code has services, events, or workflows.

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
