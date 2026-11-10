# Vertical Slice for Spec-Kit

[![self-test](https://github.com/Scrollout/speckit-vertical-arch/actions/workflows/self-test.yml/badge.svg?branch=main)](https://github.com/Scrollout/speckit-vertical-arch/actions/workflows/self-test.yml)
[![vertical-slice](https://img.shields.io/badge/vertical--slice-0.25.0-blue)](presets/vertical-slice/CHANGELOG.md)
[![vsa](https://img.shields.io/badge/vsa-0.19.0-blue)](extensions/vsa/CHANGELOG.md)
[![Spec Kit](https://img.shields.io/badge/Spec%20Kit-%3E%3D1.2.5-informational)](https://github.com/github/spec-kit)
[![license: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)

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

## Self-test

`scripts/self-test.sh` installs the preset and the extension into a throwaway Spec-Kit project and checks:

- The preset and extension versions match each other's supported ranges, and every declared file exists.
- The core text each override takes precedence over still exists in core.
- The preset installs without vsa, since vsa is optional.
- Every overridden command is delivered with its marker, and every template resolves to the preset.
- Both vsa hooks are registered.
- The README badges match the manifests.
- The commands, the tasks template, the constitution addendum, and the vsa check each still state their rule for the `#### Open items` group.
- Every principle in the constitution addendum is one paragraph of at most 1,000 characters, the definition of a test change is stated only in the implement rules' Changing tests, every file that depends on it still points to it, the entry template keeps every kind and field the vsa check reads, and the template resolves.
- Removal leaves no markers.

It runs Spec-Kit `v1.2.5` through `uvx` by default. Set `SPECKIT_REF` to test another tag, or `SPECIFY=specify` to use an installed CLI. CI runs it on every push and pull request.
