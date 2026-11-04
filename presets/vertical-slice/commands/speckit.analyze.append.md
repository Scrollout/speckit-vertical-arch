<!-- vertical-slice:analyze-rules -->

## Vertical Slice Consistency Checks

These checks take precedence over any stock text above that they conflict with. For example, the severity heuristic would rank a layered task order as "Style/wording improvements, minor redundancy not affecting execution order", and these checks rank it MEDIUM or higher.

Add these checks to the detection passes, and report failures as findings with MEDIUM severity or higher:

- Every user story in `spec.md` appears in the plan's Slice Map.
- Every implementation task sits under a `Slice` or `Shared` heading in `tasks.md`.
- No task group is ordered by technical layer.
- Every interaction between contexts names a contract.
- A domain rule used by two or more slices has one owner.
- Every planned file path follows the Project Structure, no context exists only for a stack or for a client, every value has the home the plan's value table gives it, and each value is defined once.
