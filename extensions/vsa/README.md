# Vertical Slice Check Extension

Adds `speckit.vsa.check`, which checks a feature's artifacts and code against the vertical slice rules. It changes nothing.

## Requirements

- Spec-Kit 1.2.5 or later.
- The `vertical-slice` preset. An extension manifest cannot require a preset, so the check tests for it when it runs and reports `NOT RUN` if it's missing or disabled.

## Install and remove

```bash
specify extension add --dev <path-to-this-folder>
specify extension remove vsa
```

## When it runs

- Automatically after `/speckit-tasks` and `/speckit-implement`.
- On demand with `/speckit-vsa-check`.

## Rules

| Rule | Finding | Severity |
|---|---|---|
| VSA-001 | A file outside its place in the Project Structure that needs reading to judge, or technical-layer folders as the primary structure | Blocking |
| VSA-002 | Tasks ordered by technical layer | Blocking |
| VSA-003 | Reach into another slice's or context's internals that a static check cannot see | Blocking |
| VSA-004 | A domain rule duplicated across slices of one context, or a possible duplicate | Warning |
| VSA-005 | A value outside its home, or a `manifest` written as code | Blocking |
| VSA-006 | The test command does not run the boundary check, the contract checks, and every context's tests, or passes when one finds a problem, is missing, or checked nothing; or the boundary check misses a planning rule, or a context has no tests | Blocking |


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

To accept an exception, add a row to the plan's Complexity Tracking table naming the rule, the location, and the reason.
