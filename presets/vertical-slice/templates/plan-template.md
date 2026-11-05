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
  List every context this feature touches, including client contexts owned by another team.
  A context is a boundary of domain language, data, and ownership. A language or a screen does not
  create one, so one context may list several stacks.
  Use "unassigned" for an unknown owner.
  CQRS decision is "same store" (default) or "separate read model", which needs a reason and a Read Models row.
  Deployment unit is "service" when the context deploys on its own, as a service named for the context,
  or "module in <host>" when it shares a process in hosts/<host>/. A service never spans two contexts.
  Record it in the context's manifest too; the manifest is the lasting record.
-->

| Context | Owner | Stack | CQRS decision | Deployment unit |
|---|---|---|---|---|
| [Context] | [Team or unassigned] | [Stack or stacks] | Same store (default) | [service, or module in <host>] |

## Slice Map

<!--
  One row per slice. A slice is one command or query. In a library or command-line tool,
  a slice is one behavior a caller can invoke. Every user story must appear at least once.
  UI reach is one of: includes client, ends at contract, no UI.
  Set UI reach by ownership, not by stack. Use "includes client" when one team owns the whole path,
  even across stacks. Use "ends at contract" when another team
  owns the client.
-->

| Slice | Kind | Stories | Context | UI reach | Client feature slice | Contract |
|---|---|---|---|---|---|---|
| [SliceName] | command | US1 | [Context] | [UI reach] | [Name or None] | [Name or None] |

## Shared Domain Rules

<!-- A rule goes here only when two or more slices use it. Write None when no rule is shared. -->

| Rule | Owner | Used by |
|---|---|---|
| [Rule] | [One location] | [SliceA, SliceB] |

## Contracts Between Contexts

<!-- Every interaction between contexts names a contract. Write None for one context and no client boundary. -->

| Contract | Provider | Consumers | Kind |
|---|---|---|---|
| [contract-name] | [Context] | [Context or client] | [API, event, or schema] |

## Deployment Topology

<!--
  Delete this section unless contexts deploy as separate services.
  One row per context deployed as a service. The service has the context's name, and each program deploys as
  <context>-<trigger>, such as orders-http. The service owns its store, and no other context reads or writes it.
  These rows mirror each context's manifest. When this feature changes them, it changes the manifest too.
-->

| Service (= context) | Programs → deployables | Store (owned) | Scales independently |
|---|---|---|---|
| [context] | [http → [context]-http, queue → [context]-queue] | [Store, owned by this context only] | [Yes or No] |

## Events

<!--
  Delete this section unless contexts exchange events.
  Name each event as a noun and a past-tense verb, such as OrderPlaced, because it records a fact.
  Its contract folder uses the same name in kebab-case, such as contracts/order-placed/v1/.
  Every event is also a row in Contracts Between Contexts, with kind "event", and in the publisher's
  and consumers' manifests.
  Published via is "outbox" unless Slice Rule Exceptions records a reason.
-->

| Event | Version | Publisher | Consumers | Published via | Consumer idempotency key |
|---|---|---|---|---|---|
| [NounPastTense, such as OrderPlaced] | v1 | [Context] | [Context, Context] | outbox | [Field or fields] |

## Workflows

<!--
  Delete this section unless a business process spans contexts.
  Every step that changes state has a compensation, and every workflow has a timeout.
  The workflow's state lives in the owner's domain/[workflow_name]_workflow/. Each step and each
  compensation is a slice named for what it does, and a compensation is named for the action that undoes
  its step, such as release_stock for reserve_stock.
-->

| Workflow | Owner context | Steps (event → slice) | Compensation per step | Timeout |
|---|---|---|---|---|
| [workflow_name] | [Context] | [EventA → slice_a, EventB → slice_b] | [slice_a: undo_slice_a, slice_b: undo_slice_b] | [Duration and the slice it starts] |

## Read Models

<!--
  Delete this section unless a context's CQRS decision is "separate read model".
  The projection slice that writes a read model is named update_[read_model]. Query slices that read it are
  named get_[noun] or list_[nouns].
-->

| Read model | Context | Fed by events | Served by slice | Rebuild |
|---|---|---|---|---|
| [read_model] | [Context] | [EventA, EventB] → update_[read_model] | [get_ or list_ slice] | [How it is rebuilt from events or the write store] |

## Existing Code

<!-- Delete this section unless the feature touches a project with layered code. Do not plan to restructure existing code. -->

[Where new slices live, and how they call existing code]

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (__SPECKIT_COMMAND_PLAN__ command output)
├── research.md          # Phase 0 output (__SPECKIT_COMMAND_PLAN__ command)
├── data-model.md        # Phase 1 output (__SPECKIT_COMMAND_PLAN__ command): shared domain, then one section per slice
├── quickstart.md        # Phase 1 output (__SPECKIT_COMMAND_PLAN__ command)
├── contracts/           # Phase 1 output (__SPECKIT_COMMAND_PLAN__ command)
└── tasks.md             # Phase 2 output (__SPECKIT_COMMAND_TASKS__ command - NOT created by __SPECKIT_COMMAND_PLAN__)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout for this feature.
  Use the planning rules' Project Structure: every context has this shape, and every file has one
  place. Delete the parts a context does not need. In a project with no client, a slice has no
  client/ or server/ subfolders. A framework's required folder may appear inside a slice or at a
  project boundary. Name each program folder in apps/ by what starts it, never by the context's name.
-->

```text
[context]/               # One fixed place per context, however it deploys; also the service name
├── manifest.[ext]       # What the context declares: owner, deployment unit, programs, owned store,
│                        #   published types and events with versions, consumed events with versions
├── contracts/
│   └── [contract-name]/
│       └── [version]/   # One contract document per published version, such as openapi.yaml or
│                        #   asyncapi.yaml, and nothing else. Each contract is versioned on its own
├── apps/[trigger]/      # One deployed program, named by what starts it (http, queue, schedule, cli), never the context's name:
│                        #   entry point, wiring, routing, shared client host. Deploys as [context]-[trigger]
├── infrastructure/      # Store setup (open, schema, transactions, seed data), outbox, inbox, relay code, and hosting. No slice queries
├── domain/              # Rules two or more slices need for correctness, and workflow state in [workflow_name]_workflow/
├── features/
│   └── [slice_name]/    # verb_noun in snake_case, named for what it does, never for what triggers it
│       ├── server/      # Role-named files: endpoint, handler,
│       │                #   request, response (may share one file); repository always its own file
│       ├── client/      # The slice's client, when UI reach is includes client
│       └── tests/       # The slice's tests, never shipped
└── [files a stack requires at the root]

hosts/[host-name]/       # Only when contexts share one process: entry point and wiring that start each
                         #   context's apps/[trigger]/. No feature code, no business rules
tests/integration/       # Tests that cross contexts or run the whole system
```

<!--
  Services, events, and workflows use the same shape:
  - An event consumer, a projection, and a workflow step are each a slice in features/, listed in apps/queue/.
  - A timeout is apps/schedule/ starting a slice.
  - The outbox relay runs as a line in apps/queue/, or as its own program in apps/outbox/ when it must run alone.
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
