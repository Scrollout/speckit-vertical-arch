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

2. Read the `version` of the `vertical-slice` entry. This check supports `>=0.20.0` and `<0.21.0`. If the version is outside that range, print the report with status `NOT RUN` and this message, then stop:

   ```text
   The vsa check supports vertical-slice 0.20.x, but this project has <version>. Install matching versions of the preset and the extension.
   ```

3. Read `feature_directory` from `.specify/feature.json`. If the file is missing, or the directory does not exist, print the report with status `NOT RUN`, say that no current feature could be found, then stop.

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
| VSA-007 | A store read or written by more than one context | Blocking |
| VSA-008 | An event published without an outbox or a named relay, or a consumer with no idempotency key or that does not record it in the inbox in the same transaction as its state change | Blocking |
| VSA-009 | A workflow step that changes state with no compensation, or a workflow with no timeout | Blocking |
| VSA-010 | An event published or consumed that is missing from the plan's Events table, its versioned contract, or a manifest, or that is not named in the past tense | Blocking |

Check VSA-006 first. When the test command runs the boundary check and the check covers every planning rule, a direct import is that check's job, and the review does not repeat it. The judgment rules are read in full whatever the checks report.

- VSA-001: check the plan's Project Structure and the code against the planning rules' Project Structure. The named folders inside a slice do not count as layers. A framework-required folder at a project boundary does not count. Each of these is a finding:
  - a context that exists only for a stack or for a frontend, such as `orders-ui/` beside `orders/` with the same owner;
  - a frontend outside its slice when one team owns the whole path, or code in a slice's `frontend/` that calls another context other than through its contract;
  - a slice with both sides whose tests are not split into `tests/backend/` and `tests/frontend/`;
  - a CSS class, custom element, browser event, or storage key in a `frontend/` without its context's kebab-case prefix;
  - a backend file named for no role, or a `handler`, `event`, or `repository` sharing a file with another role;
  - helpers in `domain/`;
  - business rules or one slice's behaviour in `entrypoints/` or `infrastructure/`;
  - two stacks in one folder;
  - a test, test case, or script in `contracts/[contract-name]/[version]/`, whose tests belong in the slice that provides the operation;
  - a test outside its owner's `tests/` folder, unless its stack requires tests beside the code and leaves them out of its build;
  - a program folder in `entrypoints/` whose name repeats its context's name, such as `orders/entrypoints/orders/`, in the plan's Project Structure or in code;
  - a context placed anywhere other than `[context]/`, such as `services/orders/`;
  - a service that spans two contexts, or a service or deployed program not named as its context, and its trigger, in kebab-case, such as `order-management-http` for `order_management/entrypoints/http/`;
  - feature code or business rules in `hosts/`;
  - a contract document outside its provider's `contracts/[contract-name]/[version]/`, or one version folder that holds two contracts;
  - an AsyncAPI document for a single event, or more than one AsyncAPI document in a context;
  - a deployed name longer than 63 characters, or one that does not start with a letter and end with a letter or digit;
  - a manifest that lists programs, which the `entrypoints/` folders already list;
  - a context, program, host, or `domain/` folder that is not `snake_case`, such as a hyphenated program folder in `entrypoints/`;
  - and a slice folder that is not `snake_case`, does not follow the planning rules' name for its kind, or is named for its trigger, such as `on_order_placed`.

  A program folder named by what starts it, including a name outside the planning rules' examples, such as `stream/`, is not a finding. A Shared Domain Rules row that names fewer than two slices is a finding at the review after tasks, before any code is written.
- VSA-002: check the order of tasks inside each story phase. A sequence such as models, then services, then endpoints is a finding.
- VSA-003: check reach between slices and between contexts that a static check cannot see, such as a shared file, a string route, or an environment value one side sets and the other reads. Using a shared owner or a named contract is allowed. Report a direct import here only when VSA-006 found the boundary check missing, not run by the test command, or not covering that rule.
- VSA-004: report a warning when two slices of the same context appear to hold the same rule, even if you are unsure. Similar data access in two slices' repositories is not a finding: each slice owns its reads and writes. Only a duplicated rule that decides correctness is. A copy in another context is not a finding: contexts share no code, and each owns its own model.
- VSA-005: search all code outside tests for values that vary between deploys, such as addresses, ports, file paths, and credentials, and for published types and versions outside `manifest` and contract documents. Compare every limit, pattern, enum, and error code the code enforces on a request with the contract document: one the contract does not declare is a finding, unless a contract test proves the code matches it. So is business data, such as roles or policies, written in code, and a `manifest` written as code. A local default in `entrypoints/` that is not a credential does not count, nor do tests and contract examples. Report a bare or repeated internal value as a VSA-004 warning.
- VSA-006: read the plan, the project's test command, and how it decides its exit code. Report the boundary check or the contract checks missing from the test command, a step that exits 0 when its tool is missing or when it checked nothing, a boundary rule from the planning rules that the check's configuration does not cover, a contract check missing for a context that publishes versioned contracts, a context with no tests, and a deployed artifact that can hold a test file: no exclusion of `tests/` for its stack, or no check of the built artifact in the test command.
- VSA-007 to VSA-010 apply only when the plan has a Deployment Topology, Events, or Workflows section, or the code publishes or consumes events. Otherwise skip them and say so under **Examined**.
- VSA-007: check each context's `manifest`, the plan's Deployment Topology, and the code for a store that two contexts own, open, query, or migrate. A context reading another's data through its contract or through its own read model is not a finding.
- VSA-008: for each publishing slice, check that the event is written to the outbox in the same transaction as the state change, and that the plan's Events table names the relay. For each consumer slice, check that the plan's Events table names its idempotency key and that the code records it in the inbox in the same transaction as the consumer's state change.
- VSA-009: for each row in the plan's Workflows table, check that every step that changes state names a compensation slice that exists, and that the timeout is started from `entrypoints/schedule/`.
- VSA-010: compare every event the code publishes or consumes with the plan's Events table, the publisher's `contracts/[contract-name]/[version]/`, and the publisher's and consumer's `manifest`. An event missing from any of them is a finding, and so is an event name that is not a noun and a past-tense verb.

## 4. Exceptions

An exception matches when a row in the plan's Slice Rule Exceptions table names the rule and the location and gives a reason. Report a matched finding under **Accepted exceptions**, not in the findings table.

## 5. Report

Print this report, using the highest applicable status. Each row's first column is the rule ID, such as `VSA-003`, one row per finding:

- `FAIL`: at least one blocking finding has no matching exception. The next step tells the developer not to proceed until it is fixed or a justified exception is recorded.
- `WARN`: no unaccepted blocking findings, and at least one warning. Work may continue.
- `PASS`: no unaccepted findings in the examined artifacts.
- `NOT RUN`: a precondition failed. This is never a pass.

```markdown
## VSA Check: <FAIL | WARN | PASS | NOT RUN>

**Feature**: <feature directory>
**Examined**: <artifacts and code scope>
**Not examined**: <artifacts and reasons, or None>

| Rule | Severity | Finding | Location | Detail |
|---|---|---|---|---|

**Accepted exceptions**: <rule, location, and reason, or None>

**Next step**: <what to do>
```
