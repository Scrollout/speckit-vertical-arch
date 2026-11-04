<!-- vertical-slice:plan-rules -->

## Vertical Slice Planning Rules

These rules apply to every plan. They take precedence over any instruction above that conflicts with them, such as "Extract entities from feature spec" into one feature-wide `data-model.md`, which these rules divide into a shared domain section and one section per slice.

- Name every bounded context the feature touches, including client contexts owned by another team, in the Bounded Contexts section. A context is a boundary of domain language, data, and ownership. A language, a runtime, a screen, or a deployable part does not create one, so a context may list several stacks. One team may own several contexts when their domain language differs.
- Fill the Slice Map. Each command and each query is one slice. In a library or command-line tool, a slice is one behavior a caller can invoke. Every user story maps to at least one slice, and every slice has one context.
- Organize code by context and then by slice, using the Project Structure below. Do not propose technical-layer folders as the primary structure. A framework's required folder may appear inside a slice or at a project boundary.
- Organize `data-model.md` into a shared domain section, followed by one section per slice for its request, response, and view models. Keep the file name.
- List a domain rule in Shared Domain Rules only when two or more slices use it, and give it one owner. Reuse is not a reason to share a model. Correctness is.
- When the project has layered code, add the Existing Code section. State where the new slices live and how they call existing code. Do not plan to restructure it.

### Project Structure

Every context uses this structure, whatever its stacks. It fixes where a file goes, so every file has exactly one place. It does not fix how a slice works: each slice takes the simplest implementation that meets its request, and is refactored when the code calls for it.

| Place | Holds |
|---|---|
| `[context]/features/[slice-name]/` | Everything one request needs, from the client to the stored data: its shapes, validation, handling, data access, and tests. Name the slice as a verb and a noun |
| `[context]/features/[slice-name]/client/` and `server/` | The two sides of a slice, in a project with a client. The slice's tests for both sides sit in its `tests/` folder. A slice has one or both. In a project with no client, these subfolders do not exist |
| Files in a slice's server side | Named by role in the stack's own style: `endpoint` (route, and the transport in and out), `handler` (the use case: validate, decide, call the repository), `request` and `response` (the slice's shapes), and `repository` (this slice's reads and writes of stored data). `repository` is always its own file. The other roles may share one file until the slice grows. Leave out a role the slice does not need |
| `[context]/domain/` | Rules that two or more slices need for correctness, with their tests. Not data access, helpers, or request and response shapes |
| `[context]/infrastructure/` | Store setup and other technical capabilities, with their tests: opening the store, the schema, transactions, the seed data files that load the store, and hosting. No business rules, and no reads or writes that belong to one slice |
| `[context]/apps/[trigger]/` | One folder per deployed program, named by what starts it, such as `http` for incoming requests, `queue` for queued work, `schedule` for timed runs, and `cli` for operator commands, and the list is not closed. The name is never the context's name, which the context folder already says. Every context keeps this one level, even with one program. It holds only the entry point, Composition Root, routing or the job list, and the client host its slices share: no feature code and no business rules |
| `[context]/contracts/[version]/` | The contract document for each published version, such as `openapi.yaml` for an HTTP API, and nothing else: no tests, test cases, or scripts. A contract's tests sit in the `tests/` folders of the slices that provide its operations |
| `[context]/manifest.[ext]` | What the context declares to the platform: its types and the versions each supports |

- No code sits at the context root: every source file goes in one of the places above. The root holds `manifest`, documentation, and files a stack or tool requires there.
- Each slice reads and writes stored data in its own `repository`, over the store setup in `infrastructure/`. A read or write that two slices need for correctness belongs to `domain/` with one owner, never to a shared repository.
- Adding a slice adds files. Shared code changes only to list the slice in `apps/`, in one line.
- Two programs started the same way get names that differ and still say what starts them, such as `http-public` and `http-internal`.
- A program started in two ways is named for its main trigger, and the plan says what else starts it.
- A portal shell served to browsers is named for incoming requests.
- Each owner keeps its tests in its own `tests/` folder: `features/[slice-name]/tests/`, `domain/tests/`, `infrastructure/tests/`, and `apps/[trigger]/tests/`, so a slice still owns its tests and no test sits among the code. A stack that requires tests beside the code and leaves them out of its build keeps them there, such as Go's `_test.go` files. Tests that cross contexts sit in `tests/integration/`.
- Slice folders use one naming style across the repository, chosen so that every stack can import them.
- Config is everything that is likely to vary between deploys, such as addresses, ports, file paths, and credentials. It is strictly separate from code and comes from environment variables.
- Every value has one home, chosen by what it is:

  | Value | Home |
  |---|---|
  | Config: varies between deploys, such as addresses, ports, file paths | Environment variables |
  | Credentials and tokens | Environment variables or files outside the repository, never in it |
  | Published facts that clients see: types, versions, properties, limits, patterns, enum values, error codes | The contract document for each version, and `manifest` for types and versions. Code reads them or a contract test proves the code matches them |
  | Business data an operator changes without a release, such as roles, policies, locks, allowed locations | The context's store, changed through its API or a seed data file |
  | Internal implementation values that no client sees and no deploy changes, such as a retry delay or buffer size | Code, each named and defined once |

- A value is data whenever someone outside the code needs to read or change it. Only the last row stays in code.
- A program in `apps/` may supply a default for local runs, and never a credential.
- `manifest` is a data file, never code. It lists each type the context publishes and the versions it supports, and each version's contract document says what that version adds. Registration, request checks, and response shaping read them. A client takes the version it uses from the provider's published list. Adding a version that only adds fields adds a contract document, changes `manifest` and the slices that use the new field, and changes no version check.

### Boundary check

- The plan names one static dependency check for each stack, using the stack's established checker, with its configuration in the repository. Examples: Import Linter for Python, dependency-cruiser for JavaScript and TypeScript, Packwerk for Ruby. Its rules: a slice does not import another slice; a context imports another context only through a named contract; `domain/` and `infrastructure/` never import `features/`; only `apps/` imports slices; and only a slice's `repository` and `infrastructure/` import the store's access library.
- Where a context publishes versioned contracts, lint every contract document and check that each newer version only adds to the one before. Examples for OpenAPI: Spectral for lint, and oasdiff's breaking-change check for the additive rule.
- The project's one test command runs the boundary check, the contract checks, and every context's tests. It fails when a check finds a problem, when a check's tool is missing, or when a check or a context's tests found nothing to check.
- Every deployed artifact, such as a container image or a package, leaves out every `tests/` folder and test file, by one rule the plan names for each stack. Example: `**/tests/` in `.dockerignore`. The test command lists the files in each artifact it builds and fails when one holds a test file.
- Record existing violations in a list the check reads, so only new ones fail, and give the list an owner.

### Polyglot and multi-team features

- One plan covers the whole feature, even when it spans several languages or contexts. A specific language, framework, mediator, or runtime mapper is not required.
- Every interaction between contexts goes through a named shared contract, listed in Contracts Between Contexts. Domain types stay inside their context and are never generated from a contract.
- Record one CQRS decision per context. The default is `same store`: separate read and write code over one store. Anything else needs a reason.
- Set UI reach for each slice by ownership, not by stack. When one team owns the whole path, the slice is `includes client`, whatever the stacks. When another team owns the client, the slice is `ends at contract`, and the plan names a linked client feature slice, owned by that team, that interacts only through that contract.
- A screen that needs data from several slices is its own read slice in the owning context, or a client feature slice when another team owns it. It does not reach into other slices' internals.
