---
description: Check the current feature's artifacts and code against the vertical slice rules. Read-only.
---

<!-- vertical-slice:check -->

## User Input

```text
$ARGUMENTS
```

## Rules for this command

This command is read-only. Do not change any artifact or code. Report only what you examined.

## 1. Preconditions

1. Read `.specify/presets/.registry`. If `vertical-slice` is missing, or its entry has `enabled: false`, print the report below with status `NOT RUN` and this message, then stop:

   ```text
   The vsa check needs the vertical-slice preset, which is not active in this project.
   ```

2. Read `feature_directory` from `.specify/feature.json`. If the file is missing, or the directory does not exist, print the report with status `NOT RUN`, say that no current feature could be found, then stop.

## 2. Scope

- **Artifacts**: the feature's `plan.md`, `data-model.md`, `tasks.md`, and `contracts/`.
- **Code**: file paths named in `tasks.md`. When git is available, add files changed since the merge base with the default branch, including uncommitted changes. Without git, use the task paths and say so in the report.
- **Excluded**: existing code that the feature did not add or change. Do not report it.

List anything in scope that does not exist under **Not examined**, with the reason. Never count it as passing.

## 3. Rules

| Rule | Finding | Severity |
|---|---|---|
| VSA-001 | A file outside its place in the Project Structure that needs reading to judge, or technical-layer folders as the primary structure | Blocking |
| VSA-002 | Tasks ordered by technical layer | Blocking |
| VSA-003 | A slice or context reaching into another's internals through something a static check cannot see, such as a shared file, a string route, or an environment value | Blocking |
| VSA-004 | A domain rule duplicated across slices of one context, or a possible duplicate | Warning |
| VSA-005 | A value outside its home, or a `manifest` written as code | Blocking |
| VSA-006 | The test command does not run the plan's boundary check, its contract checks, and every context's tests, or passes when one of them finds a problem, is missing, or checked nothing. Or the boundary check does not cover a rule the planning rules give it, or a context has no tests | Blocking |

Check VSA-006 first. When the test command runs the boundary check and the check covers every planning rule, a direct import is that check's job, and the review does not repeat it. The judgment rules are read in full whatever the checks report.

- VSA-001: check the plan's Project Structure and the code against the planning rules' Project Structure. The named folders inside a slice do not count as layers. A framework-required folder at a project boundary does not count. Each of these is a finding: a context that exists only for a stack or for a client, such as `orders-ui/` beside `orders/` with the same owner; a client outside its slice when one team owns the whole path; helpers in `domain/`; business rules or one slice's behaviour in `apps/` or `infrastructure/`; two stacks in one folder; a test, test case, or script in `contracts/[version]/`, whose tests belong in the slice that provides the operation; a test outside its owner's `tests/` folder, unless its stack requires tests beside the code and leaves them out of its build; and a program folder in `apps/` whose name repeats its context's name, such as `orders/apps/orders/`, in the plan's Project Structure or in code. A program folder named by what starts it, including a name outside the planning rules' examples, such as `stream/`, is not a finding. A Shared Domain Rules row that names fewer than two slices is a finding at the review after tasks, before any code is written.
- VSA-002: check the order of tasks inside each story phase. A sequence such as models, then services, then endpoints is a finding.
- VSA-003: check reach between slices and between contexts that a static check cannot see, such as a shared file, a string route, or an environment value one side sets and the other reads. Using a shared owner or a named contract is allowed. Report a direct import here only when VSA-006 found the boundary check missing, not run by the test command, or not covering that rule.
- VSA-004: report a warning when two slices of the same context appear to hold the same rule, even if you are unsure. A copy in another context is not a finding: contexts share no code, and each owns its own model.
- VSA-005: search all code outside tests for values that vary between deploys, such as addresses, ports, file paths, and credentials, and for published types and versions outside `manifest` and contract documents. Compare every limit, pattern, enum, and error code the code enforces on a request with the contract document: one the contract does not declare is a finding, unless a contract test proves the code matches it. So is business data, such as roles or policies, written in code, and a `manifest` written as code. A local default in `apps/` that is not a credential does not count, nor do tests and contract examples. Report a bare or repeated internal value as a VSA-004 warning.
- VSA-006: read the plan, the project's test command, and how it decides its exit code. Report the boundary check or the contract checks missing from the test command, a step that exits 0 when its tool is missing or when it checked nothing, a boundary rule from the planning rules that the check's configuration does not cover, a contract check missing for a context that publishes versioned contracts, a context with no tests, and a deployed artifact that can hold a test file: no exclusion of `tests/` for its stack, or no check of the built artifact in the test command.

## 4. Exceptions

An exception matches when the plan's Complexity Tracking table names the rule and the location and gives a reason. Report a matched finding under **Accepted exceptions**, not in the findings table.

## 5. Report

Print this report, using the highest applicable status:

- `FAIL`: at least one blocking finding has no matching exception. The next step tells the developer not to proceed until it is fixed or a justified exception is recorded.
- `WARN`: no unaccepted blocking findings, and at least one warning. Work may continue.
- `PASS`: no unaccepted findings in the examined artifacts.
- `NOT RUN`: a precondition failed. This is never a pass.

```markdown
## VSA Check: <FAIL | WARN | PASS | NOT RUN>

**Feature**: <feature directory>
**Examined**: <artifacts and code scope>
**Not examined**: <artifacts and reasons, or None>

| ID | Severity | Rule | Location | Detail |
|---|---|---|---|---|

**Accepted exceptions**: <rule, location, and reason, or None>

**Next step**: <what to do>
```
