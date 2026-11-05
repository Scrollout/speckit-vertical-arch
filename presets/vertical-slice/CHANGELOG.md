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

- Slice folder placeholders and examples use `snake_case`, such as `place_order`, replacing `place-order`, which Python and Java cannot import.
- The boundary check also requires that `hosts/` imports only each context's `apps/`.
- Program folders in `apps/` use `snake_case`, such as `http_public`, replacing `http-public`, because hosts import them.
- The Project Structure tree shows the `tests/` folders of `apps/`, `infrastructure/`, and `domain/`, which the rules already required.

- Accepted slice-rule exceptions move from Complexity Tracking to Slice Rule Exceptions. Complexity Tracking keeps Constitution Check violations only.
- Rules that refer to the review after tasks and implement apply only when the vsa check is installed.

### Fixed

- The tasks template's Polish phase no longer puts unit tests in `tests/unit/`, which broke VSA-001.
- The tasks template no longer puts cross-cutting validation and logging tasks inside a slice group.

## 0.19.0

- Previous release.
