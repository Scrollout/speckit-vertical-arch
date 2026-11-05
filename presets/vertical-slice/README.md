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
| `tasks-template` | Template with layered sample tasks | replace | Story and slice groups replace Foundational entity tasks and "Models before services" |
| `constitution-template` | Template with placeholders only | append | Offers vertical slice principles |
| `speckit.plan` | Command | append | Adds context, Slice Map, Project Structure, per-slice model, value, and boundary check rules, which take precedence over the core feature-wide `data-model.md` |
| `speckit.tasks` | Command | prepend | Slice grouping and ordering take precedence over "Tests, Models, Services, Endpoints, Integration" |
| `speckit.implement` | Command | prepend | One slice at a time, and the test command after every slice, take precedence over "Implement models, services" |
| `speckit.analyze` | Command | append | Adds slice consistency checks, which take precedence over the core severity heuristic that would rank a layered task order as "Style/wording improvements" |

## Services, events, and workflows

The plan template has four optional sections. Each is deleted unless it applies, so the preset still fits a single program, a library, or a command-line tool:

| Section | Fill it when |
|---|---|
| Deployment Topology | Contexts deploy as separate services. A service is exactly one context, has its name, and owns its store |
| Events | Contexts exchange events. Each event is a versioned contract, published via an outbox, with a consumer idempotency key |
| Workflows | A business process spans contexts. Each step that changes state has a compensation, and each workflow has a timeout |
| Read Models | A context's CQRS decision is `separate read model`. Each read model has a rebuild path |

These parts fit the existing Project Structure with no new folders inside a context:

- Consumers, projections, and workflow steps are slices listed in `apps/queue/`. Timeouts start from `apps/schedule/`.
- Workflow state lives in `domain/[workflow_name]_workflow/`. The outbox, inbox, and relay code live in `infrastructure/`.
- Each contract is versioned on its own, in its provider's `contracts/[contract-name]/[version]/`, such as `order-placed/v1/asyncapi.yaml`.
- A context stays in `[context]/` however it deploys. Its `manifest` records its owner, deployment unit, programs, owned store, and the events it publishes and consumes. Contexts that share one process are started from `hosts/[host-name]/`, which holds only wiring.

## Naming

| Thing | Name | Example |
|---|---|---|
| Context, and the service when it deploys on its own | Domain noun, `snake_case` | `orders` |
| Program and its deployable | Trigger, deployed as `[context]-[trigger]` | `apps/http/` → `orders-http` |
| Command or consumer slice | `verb_noun`, for what it does, never its trigger | `place_order`, `reserve_stock` |
| Query slice | `get_noun` or `list_nouns` | `list_my_orders` |
| Projection slice | `update_[read_model]` | `update_order_summary` |
| Compensation slice | The action that undoes its step | `release_stock` |
| Workflow state | `[workflow_name]_workflow` in `domain/` | `domain/checkout_workflow/` |
| Event | Noun and past-tense verb, contract folder in kebab-case | `OrderPlaced` → `contracts/order-placed/v1/` |

`snake_case` is the one folder style every stack can import: hyphens are not importable in Python or legal in Java packages.

This support is part of this preset, not a separate one. Spec-Kit does not merge templates: the preset with the lowest priority number replaces `plan-template` entirely, so a second preset would have to copy and maintain the whole template.

## Exceptions

Record an accepted exception to a slice rule in the plan's Slice Rule Exceptions table, with the rule, the location, and the reason. Complexity Tracking stays for Constitution Check violations.

## Testing

Run `scripts/self-test.sh` from the repository root. See the root README.
