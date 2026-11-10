# Vertical Slice Preset

Makes Spec-Kit organize plans, tasks, and implementation by bounded context and then by feature slice,
instead of by technical layer. Specifications stay technology-agnostic and are not changed.

## Install

Requires Spec-Kit 1.2.5 or later.

```bash
specify preset add --dev <path-to-this-folder>
```

Then run `/speckit-constitution` if you want to adopt the vertical slice principles. Installing the
preset does not change an existing constitution.

## Remove

```bash
specify preset remove vertical-slice
```

Removal restores the stock instructions. Spec-Kit rewrites skill formatting and keeps its own empty
bookkeeping files, so files may not be byte-identical. Principles you adopted stay in your constitution.

## What changes

Spec-Kit composition can only add text. So the strategy follows the artifact kind:

- A template is a skeleton the model copies. Where it holds layered structure, it is replaced, because composition cannot remove that structure.
- A template with no layered content gets an append.
- A command is a list of instructions. It always gets a prepend or an append whose rules state that they take precedence over the named core text. The core command stays in place, so later Spec-Kit fixes still reach it.

| Artifact | Kind | Strategy | What changes |
|---|---|---|---|
| `plan-template` | Template with layered source trees | replace | Context and Slice Map sections replace the `models/`, `services/`, and `api/` trees. Adds optional service, event, workflow, and read model sections, and Slice Rule Exceptions |
| `tasks-template` | Template with layered sample tasks | replace | Story and slice groups replace Foundational entity tasks and "Models before services". Shows an `#### Open items` group |
| `constitution-template` | Template with placeholders only | append | Offers vertical slice principles |
| `speckit.plan` | Command | append | Adds context, Slice Map, Project Structure, per-slice model, value, and boundary check rules, which take precedence over the core feature-wide `data-model.md` |
| `speckit.tasks` | Command | prepend | Slice grouping and ordering take precedence over "Tests, Models, Services, Endpoints, Integration". Keeps `#### Open items` groups when regenerating |
| `speckit.implement` | Command | prepend | One slice at a time, and the test command after every slice, take precedence over "Implement models, services". Findings get a home as `#### Open items`, which do not block phases or done |
| `speckit.analyze` | Command | append | Adds slice consistency checks, which take precedence over the core severity heuristic that would rank a layered task order as "Style/wording improvements". Accepts `#### Open items` tasks |

## Services, events, and workflows

The plan template has four optional sections. Each is deleted unless it applies, so the preset still fits a single program, a library, or a command-line tool:

| Section | Fill it when |
|---|---|
| Deployment Topology | Contexts deploy as separate services. A service is exactly one context, has its name, and owns its store |
| Events | Contexts exchange events. Each event is a versioned contract, published via an outbox, with a consumer idempotency key |
| Workflows | A business process spans contexts. It names its pivot, each step before the pivot that changes state has a compensation, and each workflow has a timeout |
| Read Models | A context's CQRS decision is `separate read model`. Each read model has a rebuild path |

These parts fit the existing Project Structure with no new folders inside a context:

- Consumers, projections, and workflow steps are slices that `entrypoints/queue/` finds from the slice folders. Each one's `entry` declares its queue or subscription and the event keys it handles. The outbox relay is polling, run from `entrypoints/queue/` or `entrypoints/outbox/`, or log tailing, an external connector the plan names. Consumers record their idempotency key in the inbox in the same transaction as their state change. Timeouts start from `entrypoints/schedule/`.
- Workflow state lives in `domain/[workflow_name]_workflow/`. The outbox, inbox, and relay code live in `infrastructure/`.
- Each contract is versioned on its own, in its provider's `contracts/[contract-name]/[version]/`, such as `order-placed/v1/schema.json` for one event's message schema. A context that uses AsyncAPI keeps one AsyncAPI document for all its events, such as `order-management-events/v1/asyncapi.yaml`.
- A context stays in `[context]/` however it deploys. Its `manifest` records its owner, deployment unit, owned store, and the events it publishes and consumes. Contexts that share one process are started from `hosts/[host_name]/`, which holds only wiring.

## Slices own their vertical

A slice owns what only it declares, so adding a slice adds files in its own folder, plus the store schema change, the `manifest` entries, and the deploy packaging its program needs:

| Part | Where |
|---|---|
| Contract source | When a context writes its contracts in a source language, such as TypeSpec, each slice's part is in its `contract` file, and shared parts and the compiler settings sit in `contracts/` beside the version folders. The emitted documents stay the contract, and a drift check fails when they differ from the sources |
| Routes and consumers | Each program finds its slices from the slice folders. An HTTP slice's `entry` exposes its routes, and a consumer slice's `entry` declares its queue or subscription and its event keys. Broker or queue configuration kept in the repository is checked against them and the `manifest` |
| Store schema | In `infrastructure/`, as one ordered migration history when the store uses migrations. Each migration names the slice it serves |

## Naming

| Thing | Name | Example |
|---|---|---|
| Context folder | Domain noun, `snake_case` | `order_management` |
| Service, when the context deploys on its own | The context's name in kebab-case | `order-management` |
| Program folder | Trigger, `snake_case` | `entrypoints/http/`, `entrypoints/http_public/` |
| Deployed program | `[context]-[trigger]` in kebab-case, at most 63 characters, starting with a letter | `order-management-http` |
| Host folder | `snake_case` | `hosts/back_office/` |
| Command or consumer slice | `verb_noun`, for what it does, never its trigger | `place_order`, `reserve_stock` |
| Query slice | `get_noun` or `list_nouns` | `list_my_orders` |
| Projection slice | `update_[read_model]` | `update_order_summary` |
| Compensation slice | The action that undoes its step | `release_stock` |
| Workflow state | `[workflow_name]_workflow` in `domain/` | `domain/checkout_workflow/` |
| Event | Noun and past-tense verb, contract folder in kebab-case holding its message schema | `OrderPlaced` → `contracts/order-placed/v1/schema.json` |
| Package or namespace | The stack's style, where the stack lets it differ from the folder | Go `package placeorder`, C# `OrderManagement.Features.PlaceOrder` |
| Frontend names in the browser | Prefixed with the context's kebab-case name | `order-management-cart`, `order-management:order-placed` |
| Backend files in a slice | By role: `entry`, `handler`, `request`, `response`, `event`, `repository`, and `contract` with a contract source language | `place_order/backend/handler.py`, `place_order/backend/contract.tsp` |

Folders that code imports are `snake_case`, the one style every stack can import: hyphens are not importable in Python or legal in Java packages. Names that leave the code are kebab-case: Kubernetes and DNS names allow only lowercase letters, digits, and `-`.

This support is part of this preset, not a separate one. Spec-Kit does not merge templates: the preset with the lowest priority number replaces `plan-template` entirely, so a second preset would have to copy and maintain the whole template.

## Evidence, decisions, and checks

These rules apply to every project:

| Rule | What it requires |
|---|---|
| Progressive distributed disclosure | Research maps the sources by their cheapest signal, opens the most promising, re-ranks after each step, follows links to primary sources only when needed, and stops at the deciding evidence. `research.md` records a Sources table |
| Act at 90% or higher | Each decision has a confidence that rests on its deciding source or a test. Decisions at 90% or higher go to Decisions; the rest go to Open Decisions, and no work acts on them |
| Checks prove they can fail | Every check finds its targets from the folders, reports what it examined, passes on clean code, and fails on a planted violation. A change that moves, renames, or restructures what a check or its planted-violation tests target runs the test command and every check's planted-violation and clean tests before it is committed, or, without git, before the next slice |
| Retired terms are guarded | Renamed or removed names, paths, and patterns are listed in a data file, and the test command fails when one returns |
| Fix the cause | A failing check or test is resolved by fixing whichever of the code, the check, or the test is wrong, never by weakening the one that is right |
| Tests change only through a fresh agent | When a fresh sub-agent is available, only it changes, skips, or removes a test that judges the code, judging from the spec and the contract; a requirement a test checks changes only through a recorded clarification; a skip is a strict expected failure naming an open task |
| Fresh review | The vsa check runs in a fresh sub-agent, and a fresh sub-agent writes each slice's failing tests, when the agent supports one; otherwise the same session, reported as such. A fresh sub-agent works in its own copy of the repository, in a folder of its own. When git is available, the copy includes the default branch and the working tree's uncommitted changes, including untracked files. The brief names the feature directory |
| Findings have a home | Each review warning, and each case a fresh sub-agent reports as untested, is fixed, or recorded as a task in an `#### Open items` group of its phase, or as a checked task ending `closed: <reason>` there, before the work it concerns is reported done |

## Exceptions

Record an accepted exception to a slice rule in the plan's Slice Rule Exceptions table, with the rule, the location, and the reason. Complexity Tracking stays for Constitution Check violations.

## Testing

Run `scripts/self-test.sh` from the repository root. See the root README.
