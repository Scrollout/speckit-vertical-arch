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

2. Read the `version` of the `vertical-slice` entry. This check supports `>=0.23.0` and `<0.24.0`. If the version is outside that range, print the report with status `NOT RUN` and this message, then stop:

   ```text
   The vsa check supports vertical-slice 0.23.x, but this project has <version>. Install matching versions of the preset and the extension.
   ```

3. Read `feature_directory` from `.specify/feature.json`. If the file is missing, or the directory does not exist, print the report with status `NOT RUN`, say that no current feature could be found, then stop.

## 2. Reviewer

The author of the work should not review it. Use the first variant that is possible, and never ask the user to run anything.

1. If this prompt contains the line `You are the fresh reviewer`, you are the fresh reviewer: continue with Scope.
2. Otherwise, if you can start a sub-agent with no prior context, start one. Give it only the full text of this command, the feature directory, the line `You are the fresh reviewer`, and, on a re-run, the previous report. Print its report as the result, with **Reviewer**: `fresh sub-agent`, and add no findings of your own. When the reviewer runs the test command or any other tool that writes, it works in its own copy of the repository, in a folder of its own, with its own state. It never runs git in the real working tree and never writes there. Parallel reviewers never share a folder.
3. Otherwise, record **Reviewer**: `same session (fresh review NOT RUN: no sub-agent support)`, and run the check yourself. Rely only on the files, and disregard what you remember about writing them.

On a re-run, the prompt includes the previous report. Verify each of its findings first, then review only the artifacts and code changed since that report, and report what is still open and what is new.

## 3. Scope

- **Artifacts**: the feature's `plan.md`, `research.md`, `data-model.md`, `tasks.md`, and `contracts/`.
- **Code**: file paths named in `tasks.md`. When git is available, add files changed since the merge base with the default branch, including uncommitted changes. Without git, use the task paths and say so in the report.
- **Excluded**: existing code that the feature did not add or change. Do not report it.

List anything in scope that does not exist under **Not examined**, with the reason. Never count it as passing.

## 4. Method

Find the evidence by progressive distributed disclosure. Start from the cheapest signals: the plan's tables, each context's `manifest`, the test command, and the check configurations. Open the files they name, at the smallest useful depth. After each step, re-rank what is left by how likely it is to decide a rule, and stop when each rule is decided for each location in scope. Every finding cites its evidence, and every rule that holds says why.

## 5. Rules

| Rule | Finding | Severity |
|---|---|---|
| VSA-001 | A file outside its place in the Project Structure that needs reading to judge, or technical-layer folders as the primary structure | Blocking |
| VSA-002 | Tasks ordered by technical layer, or a slice's implementation before its contract or its failing tests, or a contract, store schema, or shared model built ahead of the slice that needs it | Blocking |
| VSA-003 | A slice or context reaching into another's internals through something a static check cannot see, such as a shared file, a string route, or an environment value | Blocking |
| VSA-004 | A domain rule duplicated across slices of one context, or a possible duplicate, or a value rule checked outside its domain type | Warning |
| VSA-005 | A value outside its home, or a `manifest` written as code | Blocking |
| VSA-006 | The test command does not run the plan's boundary check, its contract checks, and every context's tests, or passes when one of them finds a problem, is missing, or checked nothing. Or the boundary check does not cover a rule the planning rules give it, or a context has no tests | Blocking |
| VSA-007 | A store read or written by more than one context | Blocking |
| VSA-008 | An event published without an outbox or a named relay, or a consumer with no idempotency key or that does not record it in the inbox in the same transaction as its state change | Blocking |
| VSA-009 | A workflow with no pivot, a step before the pivot that changes state with no compensation, or a workflow with no timeout or no recorded deadline | Blocking |
| VSA-010 | An event published or consumed that is missing from the plan's Events table, its versioned contract, or a manifest, or that is not named in the past tense | Blocking |
| VSA-011 | A task or code that acts on a decision in Open Decisions, below 90% confidence, with no confidence, or with no deciding source in `research.md` Sources | Blocking |
| VSA-012 | A check, threshold, test expectation, or report rule weakened since the merge base, or since a slice's Red point, without a reason in Slice Rule Exceptions | Blocking |
| VSA-013 | State that a rule in `domain/` guards, changed by a slice without going through that rule's owner, or one transaction that changes more than one owner's state | Blocking |

Check VSA-006 first. When the test command runs the boundary check and the check covers every planning rule, a direct import is that check's job, and the review does not repeat it. The judgment rules are read in full whatever the checks report.

- VSA-001: check the plan's Project Structure and the code against the planning rules' Project Structure. The named folders inside a slice do not count as layers. A framework-required folder at a project boundary does not count. Each of these is a finding:
  - a context that exists only for a stack or for a frontend, such as `orders-ui/` beside `orders/` with the same owner;
  - a frontend outside its slice when one team owns the whole path, or code in a slice's `frontend/` that calls another context other than through its contract;
  - a slice with both sides whose tests are not split into `tests/backend/` and `tests/frontend/`;
  - a CSS class, custom element, browser event, or storage key in a `frontend/` without its context's kebab-case prefix;
  - a backend file named for no role, or a `handler`, `event`, or `repository` sharing a file with another role;
  - when a context writes its contracts in a source language, contract source outside a slice's `contract` file and `contracts/`;
  - helpers in `domain/`;
  - business rules or one slice's behaviour in `entrypoints/` or `infrastructure/`;
  - two stacks in one folder;
  - a test, test case, script, or contract source in `contracts/[contract-name]/[version]/`, which holds only the contract documents, emitted from the sources when the context writes its contracts in a source language. Tests belong in the slice that provides the operation;
  - a test outside its owner's `tests/` folder, unless its stack requires tests beside the code and leaves them out of its build;
  - a program folder in `entrypoints/` whose name repeats its context's name, such as `orders/entrypoints/orders/`, in the plan's Project Structure or in code;
  - a context placed anywhere other than `[context]/`, such as `services/orders/`;
  - a service that spans two contexts, or a service or deployed program not named as its context, and its trigger, in kebab-case, such as `order-management-http` for `order_management/entrypoints/http/`;
  - feature code or business rules in `hosts/`;
  - a contract document outside its provider's `contracts/[contract-name]/[version]/`, or one version folder that holds two contracts;
  - an AsyncAPI document for a single event, or more than one AsyncAPI document in a context;
  - a deployed name longer than 63 characters, or one that does not start with a letter and end with a letter or digit;
  - a manifest that lists programs, which the `entrypoints/` folders already list;
  - a program in `entrypoints/` that runs its slices from a hand-kept list instead of finding them from the slice folders, unless the list is generated from the folders or the test command compares it with them;
  - a consumer slice whose `entry` does not declare its queue or subscription and the event keys it handles;
  - when the store uses migrations, a schema change outside the one ordered history in `infrastructure/`, or a migration whose header does not name the slice it serves;
  - a context, program, host, or `domain/` folder that is not `snake_case`, such as a hyphenated program folder in `entrypoints/`;
  - and a slice folder that is not `snake_case`, does not follow the planning rules' name for its kind, or is named for its trigger, such as `on_order_placed`.

  A program folder named by what starts it, including a name outside the planning rules' examples, such as `stream/`, is not a finding. Nor is a `contract` file in a slice, or shared contract source and compiler settings in `contracts/` beside the version folders. A Shared Domain Rules row that names fewer than two slices is a finding at the review after tasks, before any code is written.
- VSA-002: check the order of tasks inside each story phase. A sequence such as models, then services, then endpoints is a finding. Inside each slice group, the contract task (when the slice crosses a context boundary) and the failing-tests task must come before the implementation task; when tests are not requested, the acceptance criteria must. Setup or Foundational tasks that create tables, contract operations, or shared models for later slices are a finding. A `#### Shared:` group for a rule in the plan's Shared Domain Rules, placed directly before the first slice that uses it, is not a finding, and neither is outbox and inbox setup in Foundational, which blocks every slice that publishes or consumes.
- VSA-003: check reach between slices and between contexts that a static check cannot see, such as a shared file, a string route, or an environment value one side sets and the other reads. Using a shared owner or a named contract is allowed. Report a direct import here only when VSA-006 found the boundary check missing, not run by the test command, or not covering that rule.
- VSA-004: report a warning when two slices of the same context appear to hold the same rule, even if you are unsure. Similar data access in two slices' repositories is not a finding: each slice owns its reads and writes. Only a duplicated rule that decides correctness is. A copy in another context is not a finding: contexts share no code, and each owns its own model. Also report a value rule checked on a raw primitive when a domain type for it exists, the same value rule checked in more than one place, and a value rule in the spec or a contract with no type that enforces it in a slice that decides on it. A query slice returning stored values as primitives is not a finding.
- VSA-005: search all code outside tests for values that vary between deploys, such as addresses, ports, file paths, and credentials, and for published types and versions outside `manifest` and contract documents. Compare every limit, pattern, enum, and error code the code enforces on a request with the contract document: one the contract does not declare is a finding, unless a contract test proves the code matches it. So is business data, such as roles or policies, written in code, and a `manifest` written as code. A local default in `entrypoints/` that is not a credential does not count, nor do tests and contract examples. Report a bare or repeated internal value as a VSA-004 warning. An event type name in a slice's `event` file, a queue or subscription name and the event keys a consumer slice's `entry` declares, or a handler key in a queue program, is not a finding when it is named once and a test proves it matches the manifest; anywhere else, or without that test, it is. When the broker or queue configuration is in the repository, a test command that does not check it against what the consumer slices declare and against the `manifest` is a finding.
- VSA-006: read the plan, the project's test command, and how it decides its exit code. Report the boundary check or the contract checks missing from the test command, a step that exits 0 when its tool is missing or when it checked nothing, a boundary rule from the planning rules that the check's configuration does not cover, a contract check missing for a context that publishes versioned contracts, a drift check missing for a context that writes its contracts in a source language, or one that passes when the committed documents differ from what the sources emit or when a document has no source, a context with no tests, and a deployed artifact that can hold a test file: no exclusion of `tests/` for its stack, or no check of the built artifact in the test command. Also report a check that finds its targets from a hand-kept list the test command does not compare with the folders, such as a drift check that compiles a listed set of contract sources, a check that does not print what it examined or a test command that does not fail when a required count is zero, a check with no planted-violation test or no clean test, and a project that retired a name, path, or pattern without a retired-terms file the test command enforces.
- VSA-007 to VSA-010 apply only when the plan has a Deployment Topology, Events, or Workflows section, or the code publishes or consumes events. Otherwise skip them and say so under **Examined**.
- VSA-007: check each context's `manifest`, the plan's Deployment Topology, and the code for a store that two contexts own, open, query, or migrate. A context reading another's data through its contract or through its own read model is not a finding.
- VSA-008: for each publishing slice, check that the event is written to the outbox in the same transaction as the state change, and that the plan's Events table names the relay. For each consumer slice, check that the plan's Events table names its idempotency key and that the code records it in the inbox in the same transaction as the consumer's state change.
- VSA-009: for each row in the plan's Workflows table, check that it names its pivot, that every step before the pivot that changes state names a compensation slice that exists (the pivot and later steps need none), and that the timeout is started from `entrypoints/schedule/`. Check that the deadline the Workflows table names is recorded in the same transaction as the step that starts the wait, that the timeout slice finds overdue records through it and acts only on records still waiting, and that a second run changes nothing.
- VSA-011: compare each task and the code it names with the plan's Decisions and Open Decisions tables and `research.md` Sources. Report work that depends on an open decision, a decision below 90% or with no confidence, and a decision whose deciding source is missing or does not support it.
- VSA-012: compare each check's configuration, the test command, test expectations, and the report rules with the merge base, and each slice's tests with its Red point, reporting the test author under **Examined**. Report a removed or loosened check, a raised threshold, a widened ignore list, an assertion removed or weakened, or a failure turned into a pass, unless Slice Rule Exceptions records the reason.
- VSA-013: for each Shared Domain Rules row that names guarded state, find every slice that writes that state, from the plan's Slice Map, the tasks, the slices' repositories, and the store schema. A slice that writes it without loading the owner and asking it to make the change is a finding, such as a repository that updates a status column the owner guards. So is a slice that changes the state but is missing from the row's Used by column, and a transaction that changes two owners' state when Slice Rule Exceptions records no reason. Outbox and inbox rows in the same transaction are not a second owner, and a slice that only reads guarded state is not a finding. At the review after tasks, before code exists, a task that changes guarded state without using the owner is a finding.
- VSA-010: compare every event the code publishes or consumes with the plan's Events table, the publisher's `contracts/[contract-name]/[version]/`, and the publisher's and consumer's `manifest`. When the broker or queue configuration is in the repository, also compare its queues, subscriptions, and bindings with what the consumer slices' `entry` files declare. An event missing from any of them is a finding, and so is an event name that is not a noun and a past-tense verb.

## 6. Exceptions

An exception matches when a row in the plan's Slice Rule Exceptions table names the rule and the location and gives a reason. Report a matched finding under **Accepted exceptions**, not in the findings table.

## 7. Report

Print this report exactly, using the highest applicable status. The first line is always `## VSA Check: <STATUS>`, with nothing else on it. A re-run is shown on the **Run** line, never in the header. Each finding row's first column is the rule ID, such as `VSA-003`, one row per finding, and every row names its evidence:

- `FAIL`: at least one blocking finding has no matching exception. The next step tells the developer not to proceed until it is fixed or a justified exception is recorded.
- `WARN`: no unaccepted blocking findings, and at least one warning. Work may continue.
- `PASS`: no unaccepted findings in the examined artifacts.
- `NOT RUN`: a precondition failed. This is never a pass.

```markdown
## VSA Check: <FAIL | WARN | PASS | NOT RUN>

**Run**: <first, or re-run after fixes>
**Reviewer**: <fresh sub-agent | same session (fresh review NOT RUN: no sub-agent support)>
**Feature**: <feature directory>
**Examined**: <artifacts and code scope, and for each rule that holds, why>
**Not examined**: <artifacts and reasons, or None>

| Rule | Severity | Location | Evidence | Detail |
|---|---|---|---|---|

**Accepted exceptions**: <rule, location, and reason, or None>

**Next step**: <what to do>
```
