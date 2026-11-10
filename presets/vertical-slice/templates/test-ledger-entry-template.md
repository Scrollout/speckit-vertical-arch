# [kind]: [scope]-[n]

<!-- vertical-slice:test-ledger-entry -->

<!--
  The implement rules' Changing tests says when an entry is written, by whom, and what it must
  show, and the vsa check's VSA-014 checks each entry. This template fixes only the format of
  one entry.

  Each entry is its own file, specs/[###-feature-name]/test-ledger/[scope]-[n].md. The scope is
  the writer's: the slice it was briefed for, or the unique tag its brief gives it, such as
  `due-3`, never where the tests live, which the `test` and `files` fields say. A writer takes the
  next unused number in its scope. Refer to an entry from anywhere, such as a skip's reason or a
  task, by its path without `.md`: `specs/[###-feature-name]/test-ledger/[scope]-[n]`.

  The heading's kind is `red-point`, `stands`, `changed`, `skipped`, or `removed`. The fields follow
  as `- [field]: [value]` lines, in this order. Leave out a field its kind does not use.

  | Field | Kinds | Value |
  |---|---|---|
  | slice | red-point | The slice whose failing tests these are |
  | test | stands, changed, skipped, removed | Each test as `path::name`, comma-separated. One entry may cover the tests one fixture change affects |
  | by | all | `fresh agent [name or role]`, or `same session (no fresh agent)` |
  | judges | all but red-point | An earlier entry's reference, then `upheld` or `reversed`, when this entry judges it |
  | because | all | The requirement the entry rests on, by file and section, such as `specs/004-draft-orders/spec.md FR-002`. For a test made due by a source change, also that change. For a skip, why the code does not meet the test yet, or the sources that conflict |
  | replaced by | removed | The replacing test as `path::name`, when there is one |
  | fails on | changed, removed | The targeted change, as `file: edit`, that makes the test, or its replacement, fail by an assertion. Only when the current code passes it |
  | removed test | removed | Only without git: the removed test's text, in a fenced block below the field |
  | files | all | Each test file the entry leaves, one indented item each, as `` `[sha256]` [path] ``, or `` `deleted` [path] `` for a removed file |
  | sources | all | Each source the entry rests on, the same way |

  A hash is the lowercase hex SHA-256 of the file's bytes, such as `sha256sum` or
  `shasum -a 256` prints.

  Example, as specs/004-draft-orders/test-ledger/place_order-2.md:

  # changed: place_order-2

  - test: orders/features/place_order/tests/test_place_order.py::test_rejects_zero_quantity
  - by: fresh agent red-point-test-writer
  - because: specs/004-draft-orders/spec.md FR-002, which supersedes specs/001-orders/spec.md FR-005, allows quantity 0 for a draft order
  - fails on: orders/domain/quantity.py: accept 0 for an order that is not a draft
  - files:
    - `9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08` orders/features/place_order/tests/test_place_order.py
  - sources:
    - `60303ae22b998861bce3b28f33eec1be758a213c86c93c076dbe9f558c11c752` specs/004-draft-orders/spec.md
-->
