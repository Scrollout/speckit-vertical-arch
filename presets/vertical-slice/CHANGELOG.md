# Changelog

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
