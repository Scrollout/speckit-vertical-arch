<!-- vertical-slice:implement-rules -->

## Vertical Slice Implementation Rules

These rules take precedence over any later instruction that describes work by technical layer, such as "models, services" or "core development".

- Build one slice at a time, in the order in `tasks.md`. Finish a slice and pass its validation before starting the next one.
- A check that did not run, or found nothing to check, is a failure, never a pass. Make the project's one test command run the plan's boundary check, its contract checks, and every context's tests, and exit non-zero when any of them finds a problem, is missing, or found nothing to check. It also fails when an artifact it builds holds a test file.
- Put every file in the place the plan's Project Structure gives it. Keep each slice's request, response, and view models in that slice, and its tests in the slice's `tests/` folder. A stack that requires tests beside the code and leaves them out of its build keeps them there.
- Keep each slice's reads and writes of stored data in its own `repository` file. Its endpoint, handler, request, and response may share one file until the slice grows; split them when it does. `infrastructure/` only opens the store, defines the schema, and runs transactions.
- Do not create a second copy of a domain rule that already has an owner. When a second slice needs a rule held by the first, move the rule to its one owner, and update the first slice to use it.
- Contexts interact only through their named contracts.
- Run the test command after every slice, not only at the end. A failure is fixed before the next slice starts.
- Put every value in the home the plan's value table gives it. Read config from environment variables. Declare every limit, pattern, enum, and error code a client sees in the contract document, and have code read it or a contract test prove the match. Keep business data such as roles and policies in the store. Only internal values that no client sees and no deploy changes stay in code, each named and defined once. A client takes the version it uses from the provider's published list. Tests and contract examples may name values.
- This command is not finished while the review after it reports a blocking finding: fix each one, or record a justified exception in the plan's Complexity Tracking table, and run the review again.
- Before reporting done, stop everything the run started outside the test command, such as containers, servers, and background processes.

<!-- vertical-slice:implement-rules-end -->
