<!-- vertical-slice:implement-rules -->

## Vertical Slice Implementation Rules

These rules take precedence over any later instruction that describes work by technical layer, such as "models, services" or "core development".

- Build outside-in, test-first: the skeleton first, then for each slice its contract (only what it needs), its failing tests, and the minimal code that passes them, adding only the store schema changes those tests need. Never build a contract, a store schema, or a shared model ahead of the slice that needs it.
- Build one slice at a time, in the order in `tasks.md`. Finish a slice and pass its validation before starting the next one.
- A check that did not run, or found nothing to check, is a failure, never a pass. Make the project's one test command run the plan's boundary check, its contract checks, and every context's tests, and exit non-zero when any of them finds a problem, is missing, or found nothing to check. It also fails when an artifact it builds holds a test file.
- Put every file in the place the plan's Project Structure gives it. Keep each slice's request, response, and view models in that slice, and its tests in the slice's `tests/` folder. A stack that requires tests beside the code and leaves them out of its build keeps them there.
- Keep each slice's reads and writes of stored data in its own `repository` file. Its entry, request, and response may share one file until the slice grows; split them when it does. Its handler, event, and repository are each their own file. `infrastructure/` only opens the store, defines the schema, and runs transactions.
- Do not create a second copy of a domain rule that already has an owner. When a second slice needs a rule held by the first, move the rule to its one owner, and update the first slice to use it.
- Change state that a rule in `domain/` guards only through that rule's owner: load the owner through the slice's `repository`, ask it to make the change, and save its state. Never write that state around the owner. One transaction changes one owner's state, together with its outbox and inbox rows.
- Convert each request into its domain types in the handler before any decision. Check a value's rule only in its type, and test each type with one valid and one invalid value at every boundary of its rule.
- Contexts interact only through their named contracts.
- Run the test command after every slice, not only at the end. A failure is fixed before the next slice starts.
- Put every value in the home the plan's Values table gives it. Read config from environment variables. Declare every limit, pattern, enum, and error code a client sees in the contract document, and have code read it or a contract test prove the match. Keep business data such as roles and policies in the store. Only internal values that no client sees and no deploy changes stay in code, each named and defined once. A client takes the version it uses from the provider's published list. Tests and contract examples may name values.
- Never read or write another context's store. Publish each event through the outbox in the same transaction as the state change, from the schema in the publisher's `contracts/[contract-name]/[version]/`. Make each consumer record its idempotency key in the inbox in the same transaction as its state change, so a duplicate delivery changes nothing. Prefix every name a frontend shares in the browser with its context's kebab-case name. Give each workflow step before the pivot that changes state its compensation, as the plan's Workflows table names it, and retry the pivot and later steps until they succeed.
- When a slice raises a question the plan does not answer, resolve it by the planning rules' research method, and add it to `research.md` Sources and the plan's Decisions. When its confidence is below 85%, add it to Open Decisions, leave the code that depends on it unwritten, and continue with the rest.
- When a check fails, decide whether the code or the check is wrong, and fix the one that is wrong. Never loosen a check, a threshold, a test expectation, or a report rule to make it pass. A deliberate change to a check records its reason in the plan's Slice Rule Exceptions table.
- Keep every check's planted-violation test and clean test passing, so each check still proves it can fail.
- When the vsa check is installed, this command is not finished while the review after it reports a blocking finding: fix each one, or record a justified exception in the plan's Slice Rule Exceptions table, and run the review again, passing it the previous report. Run the review at most 3 times for this command. When the third run still reports a blocking finding, stop and report the open findings with status `FAIL`.
- Before reporting done, stop everything the run started outside the test command, such as containers, servers, and background processes.

<!-- vertical-slice:implement-rules-end -->
