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
-->

| Context | Owner | Stack | CQRS decision |
|---|---|---|---|
| [Context] | [Team or unassigned] | [Stack or stacks] | Same store (default) |

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
[context]/
├── manifest.[ext]       # What the context declares to the platform: types and their versions
├── contracts/[version]/ # Contract document for each published version, and nothing else
├── apps/[trigger]/      # One deployed program, named by what starts it (http, queue, schedule, cli), never the context's name:
│                        #   entry point, wiring, routing, shared client host
├── infrastructure/      # Store setup (open, schema, transactions, seed data) and hosting. No slice queries
├── domain/              # Rules two or more slices need for correctness
├── features/
│   └── [slice-name]/
│       ├── server/      # Role-named files: endpoint, handler,
│       │                #   request, response (may share one file); repository always its own file
│       ├── client/      # The slice's client, when UI reach is includes client
│       └── tests/       # The slice's tests, never shipped
└── [files a stack requires at the root]

contracts/               # Only when contexts or teams interact
tests/integration/       # Tests that cross contexts or run the whole system
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified, or to record an accepted exception to a slice rule**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
| [e.g., shared helper in another slice] | [specific problem] | [why a shared owner is insufficient] |
