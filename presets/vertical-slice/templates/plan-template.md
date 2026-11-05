# Implementation Plan: [FEATURE]

<!-- vertical-slice:plan-template -->

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `__SPECKIT_COMMAND_PLAN__` command; its definition describes the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]

**Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]

**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]

**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]

**Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]

**Project Type**: [e.g., library/cli/web-service/mobile-app/compiler/desktop-app or NEEDS CLARIFICATION]

**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]

**Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]

**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

[Gates determined based on constitution file]

## Bounded Contexts

<!--
  List every context this feature touches, including frontend contexts owned by another team.
  A context is a boundary of domain language, data, and ownership. A language or a screen does not
  create one, so one context may list several stacks.
  Use "unassigned" for an unknown owner.
  CQRS decision is "same store" (default) or "separate read model", which needs a reason and a Read Models row.
  Deployment unit is "service" when the context deploys on its own, as a service named for the context,
  or "module in [host_name]" when it shares a process in hosts/[host_name]/. A service never spans two contexts.
  Record it in the context's manifest too; the manifest is the lasting record.
-->

| Context | Owner | Stack | CQRS decision | Deployment unit |
|---|---|---|---|---|
| [Context] | [Team or unassigned] | [Stack or stacks] | Same store (default) | [service, or module in [host_name]] |

## Slice Map

<!--
  One row per slice. A slice is one command or query. In a library or command-line tool,
  a slice is one behavior a caller can invoke. Every user story must appear at least once.
  UI reach is one of: includes frontend, ends at contract, no UI.
  Set UI reach by ownership, not by stack. Use "includes frontend" when one team owns the whole path,
  even across stacks. Use "ends at contract" when another team
  owns the frontend.
-->

| Slice | Kind | Stories | Context | UI reach | Frontend feature slice | Contract |
|---|---|---|---|---|---|---|
| [SliceName] | command | US1 | [Context] | [UI reach] | [Name or None] | [Name or None] |

## Shared Domain Rules

<!-- A rule goes here only when two or more slices use it. Write None when no rule is shared. -->

| Rule | Owner | Used by |
|---|---|---|
| [Rule] | [One location] | [SliceA, SliceB] |

## Contracts Between Contexts

<!-- Every interaction between contexts names a contract. Write None for one context and no frontend boundary. -->

| Contract | Provider | Consumers | Kind |
|---|---|---|---|
| [contract-name] | [Context] | [Context or frontend] | [API, event, or schema] |

## Deployment Topology

<!--
  Delete this section unless contexts deploy as separate services.
  One row per context deployed as a service. The service has the context's name in kebab-case, and each program
  deploys as [context]-[trigger] in kebab-case, such as order-management-http for order_management/entrypoints/http/. The service owns its store, and no other context reads or writes it.
  Programs come from the context's entrypoints/ folders. The store and deployment unit mirror the context's
  manifest: when this feature changes them, it changes the manifest too. Deployed names are at most 63
  characters, start with a letter, and end with a letter or digit.
-->

| Service (= context) | Programs → deployables | Store (owned) | Scales independently |
|---|---|---|---|
| [context] | [http → [context]-http, queue → [context]-queue, in kebab-case] | [Store, owned by this context only] | [Yes or No] |

## Events

<!--
  Delete this section unless contexts exchange events.
  Name each event as a noun and a past-tense verb, such as OrderPlaced, because it records a fact.
  Its contract folder uses the same name in kebab-case, such as contracts/order-placed/v1/, and holds the
  event's message schema. A context that uses AsyncAPI keeps one asyncapi.yaml for all its events, as its own
  contract, such as contracts/order-management-events/v1/, that references those schemas.
  Every event is also a row in Contracts Between Contexts, with kind "event", and in the publisher's
  and consumers' manifests.
  Published via is "outbox" unless Slice Rule Exceptions records a reason. Name the relay: polling, run from
  entrypoints/queue/ or entrypoints/outbox/, or log tailing, an external connector named here.
  A consumer records its idempotency key in the inbox in the same transaction as its state change.
-->

| Event | Version | Publisher | Consumers | Published via | Relay | Consumer idempotency key |
|---|---|---|---|---|---|---|
| [NounPastTense, such as OrderPlaced] | v1 | [Context] | [Context, Context] | outbox | [polling or log tailing] | [Field or fields] |

## Workflows

<!--
  Delete this section unless a business process spans contexts.
  Name the pivot: the step after which the workflow can no longer fail. Every step before it that changes state
  has a compensation; the pivot and later steps are retried until they succeed. Every workflow has a timeout.
  The timeout needs a recorded deadline: name where the step that starts the wait records it, in the same
  transaction, such as a deadline column. The timeout slice finds overdue records through it.
  The workflow's state lives in the owner's domain/[workflow_name]_workflow/. Each step and each
  compensation is a slice named for what it does, and a compensation is named for the action that undoes
  its step, such as release_stock for reserve_stock.
-->

| Workflow | Owner context | Steps (event → slice) | Pivot | Compensation per step before the pivot | Timeout | Deadline recorded in |
|---|---|---|---|---|---|---|
| [workflow_name] | [Context] | [EventA → slice_a, EventB → slice_b] | [slice_b] | [slice_a: undo_slice_a] | [Duration and the slice it starts] | [Where, and by which slice, such as orders.deadline by place_order] |

## Read Models

<!--
  Delete this section unless a context's CQRS decision is "separate read model".
  The projection slice that writes a read model is named update_[read_model]. Query slices that read it are
  named get_[noun] or list_[nouns].
-->

| Read model | Context | Fed by events | Served by slice | Rebuild |
|---|---|---|---|---|
| [read_model] | [Context] | [EventA, EventB] → update_[read_model] | [get_ or list_ slice] | [How it is rebuilt from events or the write store] |

## Values

<!--
  Every value the feature introduces, and its one home, as the planning rules' value table gives it:
  environment variables for config, outside the repository for credentials, the contract document and
  manifest for facts a client sees, the store for business data, and code for internal values only.
-->

| Value | Home |
|---|---|
| [Value or group of values] | [Environment variable, contract document, manifest, store, or code (named once)] |

## Boundary Check

<!--
  One static dependency check per stack, with its configuration file, covering every rule the planning rules
  give it. Name the contract checks, how deployed artifacts leave out tests, and the one test command that
  runs all of them and every context's tests.
-->

- **[Stack]**: [checker], configured in [file]
- **Contracts**: [lint and additive-only check per contract kind]
- **Artifacts**: [rule that leaves tests out, and how the test command checks each built artifact]
- **Discovery**: [how each check finds contexts, slices, contracts, schemas, and artifacts from the folders]
- **Coverage**: [what each check reports it examined, and which counts must be above zero]
- **Planted violations**: [where each check's planted-violation test and clean test live]
- **Retired terms**: [data file of retired names, paths, and patterns, and its owner]
- **Test command**: [command]

## Decisions

<!--
  One row per decision the feature depends on, from research.md. Confidence rests on the deciding source or a
  test, never on assumption. Act only on decisions at 85% or higher. Move every other decision to Open Decisions.
-->

| Decision | Confidence | Deciding source |
|---|---|---|
| [What was decided] | [85–100%] | [File, URL, or test, as recorded in research.md Sources] |

## Open Decisions

<!-- Decisions below 85%, or without a deciding source. No task or code acts on them. Write None when there are none. -->

| Decision | Confidence | What would settle it |
|---|---|---|
| [Open question] | [Below 85%, or unknown] | [Source to check, test to run, or person to ask] |

## Existing Code

<!-- Delete this section unless the feature touches a project with layered code. Do not plan to restructure existing code. -->

[Where new slices live, and how they call existing code]

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (__SPECKIT_COMMAND_PLAN__ command output)
├── research.md          # Phase 0 output (__SPECKIT_COMMAND_PLAN__ command): each question, its Sources table, decision, and confidence
├── data-model.md        # Phase 1 output (__SPECKIT_COMMAND_PLAN__ command): shared domain, then one section per slice
├── quickstart.md        # Phase 1 output (__SPECKIT_COMMAND_PLAN__ command)
├── contracts/           # Phase 1 output (__SPECKIT_COMMAND_PLAN__ command)
└── tasks.md             # Phase 2 output (__SPECKIT_COMMAND_TASKS__ command - NOT created by __SPECKIT_COMMAND_PLAN__)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout for this feature.
  Use the planning rules' Project Structure: every context has this shape, and every file has one
  place. Delete the parts a context does not need. In a project with no frontend, a slice has no
  frontend/ or backend/ subfolders. A framework's required folder may appear inside a slice or at a
  project boundary. Name each program folder in entrypoints/ by what starts it, never by the context's name.
  Folders that code imports are snake_case; deployed names and contract folders are kebab-case.
  A package or namespace may follow its stack's style where the stack lets it differ from the folder,
  such as package placeorder in Go or OrderManagement.Features.PlaceOrder in C#.
-->

```text
[context]/                    # One fixed place per context, however it deploys, in snake_case, starting with a letter
├── manifest.[ext]            # What the context declares: owner, deployment unit, owned store, published types
│                             #   and events with versions, consumed events with versions
├── contracts/
│   └── [contract-name]/
│       └── [version]/        # One contract document per published version, and nothing else: openapi.yaml for
│                             #   an API, a message schema (schema.json, .avsc, .proto) for one event, or one
│                             #   asyncapi.yaml for the context's events. Each contract is versioned on its own
├── entrypoints/
│   └── [trigger]/            # One program, named in snake_case by what starts it (http, queue, schedule, cli),
│       │                     #   never by the context's name: entry point, wiring, routing, shared frontend host.
│       │                     #   Deployed as [context]-[trigger] in kebab-case (at most 63 characters), or
│       │                     #   started by a host in hosts/. The folders are the list of programs
│       └── tests/            # The program's tests, never shipped
├── infrastructure/           # Store setup (open, schema, transactions, seed data), outbox, inbox, relay code,
│   │                         #   and hosting. No slice queries
│   └── tests/
├── domain/                   # Rules two or more slices need for correctness, and workflow state
│   ├── [workflow_name]_workflow/
│   └── tests/
├── features/
│   └── [slice_name]/         # verb_noun in snake_case, named for what it does, never for what triggers it
│       ├── backend/          # Role-named files in the stack's style; leave out roles the slice does not need:
│       │                     #   entry (how its trigger reaches it), handler, request, response, event (maps a
│       │                     #   change to a published event's schema), and repository. entry, request, and
│       │                     #   response may share one file; handler, event, and repository never do
│       ├── frontend/         # The slice's user interface, when UI reach is includes frontend. Never an API
│       │                     #   client for other contexts: they use the contract
│       └── tests/            # The slice's tests, never shipped
│           ├── backend/      #   one folder per side when the slice has both, so no folder mixes stacks
│           └── frontend/
└── [files a stack requires at the root]

hosts/
└── [host_name]/              # Only when contexts share one process: the entry point and wiring that start
                              #   each context's entrypoints/[trigger]/. No feature code, no business rules
tests/
└── integration/              # Tests that cross contexts or run the whole system
```

<!--
  Services, events, and workflows use the same shape:
  - An event consumer, a projection, and a workflow step are each a slice in features/, listed in entrypoints/queue/.
  - A timeout is entrypoints/schedule/ starting a slice.
  - The outbox relay runs as a line in entrypoints/queue/, or as its own program in entrypoints/outbox/ when it must run alone.
  - A contract lives only in its provider's contracts/[contract-name]/[version]/. A repository-level index of
    contracts, if any, is generated, never edited.
-->

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |

### Slice Rule Exceptions

<!--
  One row per accepted vertical slice finding. The vsa check matches an exception on Rule and Location.
  Delete the sample row, and write None when there are no exceptions.
-->

| Rule | Location | Reason |
|---|---|---|
| [VSA-00N] | [Path or slice] | [Why the rule cannot be met here, and why a shared owner or contract is insufficient] |
