<!-- vertical-slice:tasks-rules -->

## Vertical Slice Task Rules

These rules take precedence over any later instruction in this command that organizes tasks by technical layer. That includes "Tests → Models → Services → Endpoints → Integration", "Models needed for that story, Services needed for that story", "Relationships → service layer tasks", "Shared infrastructure → Setup phase", and examples with `src/models/` or `src/services/` paths. Where a later instruction conflicts with these rules, follow these rules.

- Load the plan's Slice Map, Shared Domain Rules, and Contracts Between Contexts. Organize tasks by user story and then by slice.
- Each story phase includes its goal and independent test criteria and keeps the template's `### Tests for User Story N` and `### Implementation for User Story N` sections. Under the implementation section, it has one `#### Slice: <name>` group for each slice from the plan's Slice Map, and `#### Shared: <rule>` groups where needed.
- Give each slice the fewest tasks that keep it outside-in and test-first: a contract task when it crosses a context boundary, one task that writes its failing tests, and one that implements it, including its `repository`, only the store schema its tests need, and its line in `entrypoints/`. Add another task only for work that can run in parallel or is checked on its own.
- Every implementation task sits under one `Slice` or `Shared` heading, and its path shows the slice. Every task path follows the plan's Project Structure, and every slice folder follows the plan's naming rules, such as `reserve_stock`, `list_my_orders`, or `update_order_summary`. When a task changes what a context publishes, consumes, deploys, or owns, it also updates that context's `manifest`.
- Keep each slice's request, response, and view models and its tests in that slice. Slice models belong to their slice. A domain value type is built in the implementation task of the first slice that needs it, with its tests, and moves to `domain/` when a second slice needs it.
- Map each interface contract to the slice that provides it and the slices that consume it. When tests are requested, each operation of a contract gets a contract test in the `tests/` folder of the slice that provides it, never in `contracts/`.
- A slice marked `includes frontend` keeps its frontend tasks in its own `#### Slice:` group. A frontend feature slice exists only when another team owns the frontend. It has its own group and depends on the contract, not on backend internals.
- A `#### Shared: <rule>` group is only for a domain rule in the plan's Shared Domain Rules table. It builds the rule once in its owner, in the story where the first slice that uses it is built, and comes before that slice. When the rule guards state, the owner holds that state and its transitions, and each slice that changes the state has its implementation task change it through the owner. A rule the plan does not list stays in the slice that uses it, and moves to one owner only when implementation finds a second slice that needs it.
- A slice used by several stories is built under the earliest story, and later stories reference it.
- Setup (Phase 1) holds project initialization. Foundational (Phase 2) holds only work that blocks every slice, and each task states why. Shared entities do not go there by default. Project wiring, test tools, and other work that is not a domain rule goes in Setup when every slice needs it, and otherwise in the first slice that needs it. Never use a `Shared` group for it. Do not rebuild a Foundational phase inside the first story.
- The final phase, Polish, is for work that belongs to no single slice.
- When the plan has Events, Workflows, or Read Models rows: put the outbox and inbox setup in Foundational for each context that publishes or consumes, and give each event consumer, workflow step, compensation, and projection its own `#### Slice:` group. A consumer's tests include a duplicate delivery that changes nothing. A workflow step's tests include its compensation.
- No task acts on a decision in the plan's Open Decisions table.
- Give each check in the plan's Boundary Check section one task that writes its planted-violation test and its clean test, in Setup when every slice needs the check, and otherwise before the first slice that needs it.
- When a task renames or removes a name, path, or pattern, the same task adds the old one to the retired-terms file.
- When the vsa check is installed, this command is not finished while the review after it reports a blocking finding: fix each one in `tasks.md` or the plan, or record a justified exception in the plan's Slice Rule Exceptions table, and run the review again, passing it the previous report. Run the review at most 3 times for this command. When the third run still reports a blocking finding, stop and report the open findings with status `FAIL`.
- Order the work outside-in, test-first: Setup builds the skeleton (context folders, `manifest`, and the test command with every check proven to fail). Inside each slice group, the contract task (only when the slice crosses a context boundary, and only the version it needs) comes first, then its failing tests, then its implementation, which includes only the store schema changes its tests need. No task designs a contract, a store schema, or a shared model beyond the current slice. A rule in the plan's Shared Domain Rules table is needed by the first slice that uses it, so its `#### Shared:` group placed directly before that slice is not ahead of need. Outbox and inbox setup in Foundational is not ahead of need: it blocks every slice that publishes or consumes.
- Tasks follow the behavior being delivered, never a sequence of technical layers. When tests are requested, a slice's tests come first. The first slice must be deliverable and testable without any later slice. Each slice is a complete, independently testable increment.

Examples of correctly formatted tasks under these rules:

- `- [ ] T005 Configure request logging in orders/infrastructure/logging.py (blocks every slice because all slices log through it)`
- `- [ ] T012 [P] [US1] Write acceptance test in orders/features/place_order/tests/test_place_order.py`
- `- [ ] T014 [US1] Implement the place order behavior in orders/features/place_order/handler.py`

<!-- vertical-slice:tasks-rules-end -->
