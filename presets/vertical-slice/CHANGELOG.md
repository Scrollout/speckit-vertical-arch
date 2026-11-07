# Changelog

## 0.22.0

### Added

- A rule in `domain/` that guards state several slices change has an owner that holds that state and its transitions, its aggregate. Slices change that state only through the owner, loading and saving it through their own `repository`, and one transaction changes one owner's state with its outbox and inbox rows.
- Shared Domain Rules gains a Guards state column.
- A domain value with its own rule is a type that rejects an invalid value when it is created. The handler converts the request into these types before it decides. A type starts in its first slice and moves to `domain/` when a second slice needs it, and a limit a client sees stays in the contract. `data-model.md` lists each type, its rule, and the contract field it backs.
- Constitution principle: Values that check themselves.
- A fresh sub-agent writes each slice's failing tests, committed before any code as the slice's Red point. Constitution: Fresh review covers tests.
- Requires vsa `>=0.16.0,<0.17.0`.

### Changed

- Constitution: Single owner for rules covers guarded state; Values have one home says a value is not a domain type.
- The `handler` role decides, or has the state's owner in `domain/` decide.
- Refactor moves the object that holds guarded state with its rule.

## 0.21.0

### Added

- Outside-in, test-first order: a skeleton with checks proven to fail, then per slice only the contract it needs, its failing tests, and the minimal code, including only the store schema its tests need. The sample Foundational task sets up the store connection only.
- Constitution principle: Outside-in, test-first.

- Research by progressive distributed disclosure and reranking, with a Sources table in `research.md`.
- Decisions and Open Decisions plan sections: work acts only on decisions at 85% confidence or higher that rest on a deciding source or a test.
- Every check finds its targets from the folders, reports what it examined, and has a planted-violation test and a clean test. Tool-required lists are compared with the folders.
- A retired-terms data file that the test command enforces.
- Constitution principles: Evidence before action, Checks prove they can fail, Fix the cause, Fresh review.
- Requires vsa `>=0.15.0,<0.16.0`.

### Changed

- Workflows name their pivot. Only steps before the pivot need a compensation; the pivot and later steps are retried until they succeed. The Workflows table gains a Pivot column.
- The review after tasks and after implement runs at most 3 times per command, each re-run given the previous report, then stops and reports open findings as `FAIL`.
- A Shared group directly before its first slice, and outbox and inbox setup in Foundational, are not ahead of need.

- Implement resolves new questions by the same research method and leaves code for open decisions unwritten. A failing check is fixed at its cause, never weakened.

## 0.20.0

### Added

- Optional plan sections for services: Deployment Topology, Events, Workflows, and Read Models, and a Deployment unit column in Bounded Contexts.
- Planning, task, implement, and analyze rules for store ownership, outbox publishing, idempotent consumers, workflow compensations and timeouts, and read models.
- One fixed place per context, `[context]/`, however it deploys. A service is exactly one context and has its name. Contexts that share a process start from `hosts/[host_name]/`, which holds only wiring.
- `manifest` records the context's owner, deployment unit, programs, owned store, and the events it publishes and consumes, as the lasting record behind the plan's tables.
- Contracts are versioned on their own, in `[context]/contracts/[contract-name]/[version]/`. A contract lives only with its provider; the root `contracts/` folder is removed.
- The outbox relay runs as a line in `apps/queue/` or as `apps/outbox/`.
- Naming rules: `snake_case` slice folders, names by slice kind (`verb_noun`, `get_`/`list_`, `update_[read_model]`, compensations named for the undoing action), slices never named for their trigger, past-tense event names, `snake_case` for every folder code imports (contexts, programs, hosts, slices), kebab-case for deployed names (`order-management-http`) and contract folders, and `domain/[workflow_name]_workflow/`.
- Constitution principles: One context, one service; Names say what things do.
- Constitution principles: Services own their data, and Reliable events.
- A Slice Rule Exceptions table (Rule, Location, Reason) that the vsa check matches.
- An optional dependency on the vsa extension, `>=0.14.0,<0.15.0`.
- `repository` field, `LICENSE`, `.presetignore`, and this changelog.

### Changed

- Workflow timeouts need a recorded deadline, written in the same transaction as the step that starts the wait; the timeout slice finds overdue records through it, acts only on records still waiting, and is idempotent. The Workflows table names where the deadline is recorded.
- Event type names and queue handler keys are published facts: named once, in the slice's `event` file or the queue program, and proven equal to the manifest by a test.

- The plan template has Values and Boundary Check sections, which the rules and the vsa check already referred to.
- The boundary check expresses "only a slice's repository and infrastructure import the store library" by forbidding whole packages and exempting `*.repository` by pattern, with wildcards for every per-slice rule, so new files and slices are covered without edits.
- Similar data access in two slices' repositories is not a shared rule: each slice keeps its own repository, and only a rule that decides correctness moves to `domain/`.

- Slice folder placeholders and examples use `snake_case`, such as `place_order`, replacing `place-order`, which Python and Java cannot import.
- The boundary check also requires that `hosts/` imports only each context's `apps/`.
- Program folders in `apps/` use `snake_case`, such as `http_public`, replacing `http-public`, because hosts import them.
- Renamed `apps/` to `entrypoints/`, a slice's `server/` to `backend/` and `client/` to `frontend/`, UI reach `includes client` to `includes frontend`, and Client feature slice to Frontend feature slice. A slice's `frontend/` is its user interface, never an API client for other contexts.
- The backend role `endpoint` is now `entry`, for any trigger, and a new `event` role maps a change to a published event's schema. `handler`, `event`, and `repository` are each their own file.
- A slice with both sides splits its tests into `tests/backend/` and `tests/frontend/`, so no folder mixes stacks.
- An event's contract folder holds its message schema (`schema.json`, `.avsc`, or `.proto`). A context that uses AsyncAPI keeps one AsyncAPI document for all its events, because an AsyncAPI document describes one application.
- A consumer records its idempotency key in the inbox in the same transaction as its state change. The Events table names the relay: polling, from `entrypoints/queue/` or `entrypoints/outbox/`, or log tailing.
- Deployed names are at most 63 characters, start with a letter, and end with a letter or digit, as Kubernetes Service names require.
- A package or namespace may follow its stack's style where the stack lets it differ from the folder, such as Go's `package placeorder` in `place_order/`.
- `manifest` no longer lists programs. The `entrypoints/` folders are the list.
- Frontend names shared in the browser are prefixed with the context's kebab-case name.
- The Project Structure tree shows the `tests/` folders of `apps/`, `infrastructure/`, and `domain/`, which the rules already required.

- Accepted slice-rule exceptions move from Complexity Tracking to Slice Rule Exceptions. Complexity Tracking keeps Constitution Check violations only.
- Rules that refer to the review after tasks and implement apply only when the vsa check is installed.

### Fixed

- The tasks template's Polish phase no longer puts unit tests in `tests/unit/`, which broke VSA-001.
- The tasks template no longer puts cross-cutting validation and logging tasks inside a slice group.

## 0.19.0

- Previous release.
