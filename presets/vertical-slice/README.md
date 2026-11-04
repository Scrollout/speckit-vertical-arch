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
| `plan-template` | Template with layered source trees | replace | Context and Slice Map sections replace the `models/`, `services/`, and `api/` trees |
| `tasks-template` | Template with layered sample tasks | replace | Story and slice groups replace Foundational entity tasks and "Models before services" |
| `constitution-template` | Template with placeholders only | append | Offers vertical slice principles |
| `speckit.plan` | Command | append | Adds context, Slice Map, Project Structure, per-slice model, value, and boundary check rules, which take precedence over the core feature-wide `data-model.md` |
| `speckit.tasks` | Command | prepend | Slice grouping and ordering take precedence over "Tests, Models, Services, Endpoints, Integration" |
| `speckit.implement` | Command | prepend | One slice at a time, and the test command after every slice, take precedence over "Implement models, services" |
| `speckit.analyze` | Command | append | Adds slice consistency checks, which take precedence over the core severity heuristic that would rank a layered task order as "Style/wording improvements" |
