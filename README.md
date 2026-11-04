# Vertical Slice for Spec-Kit

A GitHub Spec-Kit customization that makes Spec-Kit plan, task, and build by bounded context and
then by feature slice, instead of by technical layer.

- `presets/vertical-slice/`: the preset. It changes the plan and tasks templates and adds rules to
  the plan, tasks, implement, and analyze commands. See its README.
- `extensions/vsa/`: the `speckit.vsa.check` review, run after tasks and after implement. See its
  README.

## Install

Requires Spec-Kit 1.2.5 or later. From the target project:

```bash
specify preset add --dev <path-to>/presets/vertical-slice
specify extension add --dev <path-to>/extensions/vsa
```

## Remove

```bash
specify extension remove vsa
specify preset remove vertical-slice
```
