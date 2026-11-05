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
| `[context]/features/[slice_name]/` | Everything one request needs, from the client to the stored data: its shapes, validation, handling, data access, and tests. Name the slice `verb_noun` in snake_case, for what it does, never for what triggers it: `reserve_stock`, not `on_order_placed` |
| `[context]/features/[slice_name]/client/` and `server/` | The two sides of a slice, in a project with a client. The slice's tests for both sides sit in its `tests/` folder. A slice has one or both. In a project with no client, these subfolders do not exist |
| Files in a slice's server side | Named by role in the stack's own style: `endpoint` (route, and the transport in and out), `handler` (the use case: validate, decide, call the repository), `request` and `response` (the slice's shapes), and `repository` (this slice's reads and writes of stored data). `repository` is always its own file. The other roles may share one file until the slice grows. Leave out a role the slice does not need |
| `[context]/domain/` | Rules that two or more slices need for correctness, with their tests. Not data access, helpers, or request and response shapes |
| `[context]/infrastructure/` | Store setup and other technical capabilities, with their tests: opening the store, the schema, transactions, the seed data files that load the store, the outbox, the inbox, the outbox relay code, and hosting. No business rules, and no reads or writes that belong to one slice |
| `[context]/apps/[trigger]/` | One folder per program, named in `snake_case` by what starts it, such as `http` for incoming requests, `queue` for queued work, `schedule` for timed runs, and `cli` for operator commands, and the list is not closed. The name is never the context's name, which the context folder already says. Every context keeps this one level, even with one program. It holds only the entry point, Composition Root, routing or the job list, and the client host its slices share: no feature code and no business rules. A program deploys as `[context]-[trigger]` in kebab-case, such as `order-management-http` for `order_management/apps/http/`, or is started by a host in `hosts/` |
| `[context]/contracts/[contract-name]/[version]/` | The contract document for each published version of one contract, such as `orders-api/v2/openapi.yaml` or `order-placed/v1/asyncapi.yaml`, and nothing else: no tests, test cases, or scripts. Each contract is versioned on its own. A contract lives only with its provider; a repository-level index, if any, is generated. A contract's tests sit in the `tests/` folders of the slices that provide its operations |
| `[context]/manifest.[ext]` | What the context declares to the platform, as the lasting record: its owner, its deployment unit, its programs, the store it owns, the types and events it publishes with the versions each supports, and the events it consumes with their versions |
| `hosts/[host_name]/` | Only when contexts share one process: the entry point and wiring that start each context's `apps/[trigger]/` together. No feature code and no business rules. Each context keeps its own `apps/`, so moving it to its own service changes no context code |

- No code sits at the context root: every source file goes in one of the places above. The root holds `manifest`, documentation, and files a stack or tool requires there.
- Each slice reads and writes stored data in its own `repository`, over the store setup in `infrastructure/`. A read or write that two slices need for correctness belongs to `domain/` with one owner, never to a shared repository.
- Adding a slice adds files. Shared code changes only to list the slice in `apps/`, in one line.
- Two programs started the same way get names that differ and still say what starts them, such as `http_public` and `http_internal`.
- A program started in two ways is named for its main trigger, and the plan says what else starts it.
- A portal shell served to browsers is named for incoming requests.
- Each owner keeps its tests in its own `tests/` folder: `features/[slice_name]/tests/`, `domain/tests/`, `infrastructure/tests/`, and `apps/[trigger]/tests/`, so a slice still owns its tests and no test sits among the code. A stack that requires tests beside the code and leaves them out of its build keeps them there, such as Go's `_test.go` files. Tests that cross contexts sit in `tests/integration/`.
- Every folder that code imports uses `snake_case`: contexts, programs in `apps/`, hosts, slices, and `domain/` folders, such as `order_management`, `http_public`, and `place_order`, because every stack can import it. Names that leave the code use kebab-case: deployed services and programs, because Kubernetes and DNS names allow only lowercase letters, digits, and `-`, and contract folders, such as `order-placed`.
- Name slices by kind:

  | Kind | Name | Example |
  |---|---|---|
  | Command or event consumer | `verb_noun`, for what it does | `place_order`, `reserve_stock` |
  | Query | `get_noun` or `list_nouns` | `get_order_status`, `list_my_orders` |
  | Projection | `update_[read_model]` | `update_order_summary` |
  | Workflow step | `verb_noun`, for what it does | `confirm_order` |
  | Compensation | The action that undoes its step | `release_stock` for `reserve_stock` |

- Name each event as a noun and a past-tense verb, such as `OrderPlaced`, and its contract folder the same in kebab-case, such as `contracts/order-placed/v1/`.
- A context is a service of the same name, in kebab-case, when it deploys on its own: `order_management` deploys as `order-management`, and its programs as `order-management-http` and `order-management-queue`. Never give a service a second name.
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
- `manifest` is a data file, never code. It records the context's owner, deployment unit, programs, and owned store, the events it consumes with their versions, and each type and event the context publishes with the versions it supports, and each version's contract document says what that version adds. Registration, request checks, and response shaping read them. A client takes the version it uses from the provider's published list. Adding a version that only adds fields adds a contract document, changes `manifest` and the slices that use the new field, and changes no version check.

### Boundary check

- The plan names one static dependency check for each stack, using the stack's established checker, with its configuration in the repository. Examples: Import Linter for Python, dependency-cruiser for JavaScript and TypeScript, Packwerk for Ruby. Its rules: a slice does not import another slice; a context imports another context only through a named contract; `domain/` and `infrastructure/` never import `features/`; only `apps/` imports slices; `hosts/` imports only each context's `apps/`; and only a slice's `repository` and `infrastructure/` import the store's access library.
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

### Services, events, and workflows

These rules apply when contexts deploy as separate services or exchange events. Fill the plan's Deployment Topology, Events, Workflows, and Read Models sections when they apply, and delete each one that does not.

- Record each context's deployment unit in Bounded Contexts and in its `manifest`: `service` when it deploys on its own, or `module in [host_name]` when it shares a process in `hosts/[host_name]/`. A context stays in `[context]/` either way, so changing how it deploys changes data, not paths or imports.
- A service is exactly one context. A context may deploy several programs, one per folder in `apps/`, but a service never spans two contexts.
- Each context owns its store, recorded in its `manifest`. No other context reads or writes it. A context that needs another context's data calls its contract or keeps a local read model fed by its events.
- Every event a context publishes is a versioned contract in its `contracts/[contract-name]/[version]/`, is listed in the publisher's and each consumer's `manifest`, has a row in Events and in Contracts Between Contexts, and is checked additive-only like any other contract.
- A slice that publishes an event writes it to the outbox in the same transaction as the state change. The outbox, the relay code, and the inbox live in `infrastructure/`. The relay runs as a line in `apps/queue/`, or as its own program in `apps/outbox/` when it must run alone.
- An event consumer is a slice, listed in `apps/queue/`. It names its idempotency key in Events, and the inbox makes a duplicate delivery change nothing.
- A business process that spans contexts has a row in Workflows. Its state and transitions live in the owner context's `domain/[workflow_name]_workflow/`. Each step is a slice. Every step that changes state names its compensation slice, named for the action that undoes it, and the workflow has a timeout started from `apps/schedule/`.
- Prefer events to synchronous calls for workflow steps. A step that needs a synchronous call records why in Slice Rule Exceptions.
- When a context's CQRS decision is `separate read model`, each read model has a row in Read Models. A projection that updates it is a slice named `update_[read_model]`, listed in `apps/queue/`, a query slice reads it through its own `repository`, and the plan says how the read model is rebuilt.

### Exceptions

- Record every accepted exception to these rules in the plan's Slice Rule Exceptions table, with the rule, the location, and the reason. Use Complexity Tracking only for Constitution Check violations.
