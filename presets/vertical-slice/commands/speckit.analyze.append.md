<!-- vertical-slice:analyze-rules -->

## Vertical Slice Consistency Checks

These checks take precedence over any stock text above that they conflict with. For example, the severity heuristic would rank a layered task order as "Style/wording improvements, minor redundancy not affecting execution order", and these checks rank it MEDIUM or higher.

Add these checks to the detection passes, and report failures as findings with MEDIUM severity or higher:

- Every user story in `spec.md` appears in the plan's Slice Map.
- Every implementation task sits under a `Slice` or `Shared` heading in `tasks.md`.
- No task group is ordered by technical layer.
- Every interaction between contexts names a contract.
- A domain rule used by two or more slices has one owner.
- Every planned file path follows the Project Structure, no context exists only for a stack or for a frontend, every value has the home the plan's Values table gives it, and each value is defined once.
- Every context stays in `[context]/`, a service is exactly one context with the context's name, and each context's `manifest` records its owner, deployment unit, owned store, and the events it publishes and consumes. Programs are the context's `entrypoints/` folders, never a manifest list. Every deployed name is at most 63 characters, starts with a letter, and ends with a letter or digit.
- Every contract sits in its provider's `contracts/[contract-name]/[version]/`, one contract per folder. An event's folder holds its message schema, and a context that uses AsyncAPI has one AsyncAPI document for all its events.
- Every slice folder is `snake_case` and follows the planning rules' name for its kind, and no slice is named for its trigger. Every event is named as a noun and a past-tense verb.
- No store is read or written by more than one context.
- Every event in the plan has a row in Events and in Contracts Between Contexts, is published via an outbox with a named relay, and names a consumer idempotency key that the inbox records in the same transaction as the consumer's state change.
- Every workflow step that changes state names a compensation, and every workflow has a timeout.
- Every context whose CQRS decision is `separate read model` has its read models in Read Models, each with a rebuild path.
