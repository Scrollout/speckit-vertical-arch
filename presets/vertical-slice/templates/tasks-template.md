---

description: "Task list template for feature implementation"
---

<!-- vertical-slice:tasks-template -->

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story, and then by slice, to enable independent implementation and testing of each story and slice.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- Paths follow the plan's Project Structure: `[context]/features/[slice_name]/` for a slice, `[context]/domain/` for a shared rule, `[context]/infrastructure/` for store setup
- Slice folders are `snake_case` and named for what they do (`reserve_stock`, `list_my_orders`, `update_order_summary`), never for what triggers them

<!--
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.

  The __SPECKIT_COMMAND_TASKS__ command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/

  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment

  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize [language] project with [framework] dependencies
- [ ] T003 [P] Configure linting and formatting tools

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks (adjust based on your project):

- [ ] T004 Setup database schema and migrations framework
- [ ] T005 [P] Implement authentication/authorization framework
- [ ] T006 [P] Setup API routing and middleware structure
- [ ] T007 Set up the store connection and schema in [context]/infrastructure/ (no slice reads or writes)
- [ ] T008 Set up the outbox, its relay, and the inbox in [context]/infrastructure/ (only when the plan's Events table lists this context; blocks every slice that publishes or consumes)
- [ ] T009 Configure error handling and logging infrastructure
- [ ] T010 Setup environment configuration management

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 1 (OPTIONAL - only if tests requested) ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T011 [P] [US1] Contract test for [endpoint] in [context]/features/[slice_name]/
- [ ] T012 [P] [US1] Integration test for [user journey] in tests/integration/ (when it crosses contexts or runs the whole system; otherwise beside its slice)

### Implementation for User Story 1, one group per slice

#### Shared: [rule] (only when the plan's Shared Domain Rules lists it)

- [ ] T013 [US1] Build [rule] once in its owner in [context]/domain/, with its tests, before the slices that use it

#### Slice: [SliceName]

- [ ] T014 [P] [US1] Write [slice] unit tests in [context]/features/[slice_name]/ (they fail first)
- [ ] T015 [US1] Implement [slice] in [context]/features/[slice_name]/: request, response, handler, endpoint, and repository, and list it in the program that serves it, [context]/apps/[trigger]/ (depends on T013, T014)

#### Slice: [SecondSliceName]

- [ ] T016 [P] [US1] Write and then implement [second slice] in [context]/features/[second_slice_name]/ the same way, using the [rule] owner

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2 (OPTIONAL - only if tests requested) ⚠️

- [ ] T017 [P] [US2] Contract test for [endpoint] in [context]/features/[slice_name]/
- [ ] T018 [P] [US2] Integration test for [user journey] in tests/integration/ (when it crosses contexts or runs the whole system; otherwise beside its slice)

### Implementation for User Story 2, one group per slice

#### Slice: [SliceName]

- [ ] T019 [P] [US2] Write [slice] unit tests in [context]/features/[slice_name]/ (they fail first)
- [ ] T020 [US2] Implement [slice] in [context]/features/[slice_name]/, and list it in [context]/apps/[trigger]/
- [ ] T021 [US2] Use the existing owner in [context]/domain/ for any rule the plan's Shared Domain Rules lists
- [ ] T022 [US2] Integrate with User Story 1 components (if needed)

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3 (OPTIONAL - only if tests requested) ⚠️

- [ ] T023 [P] [US3] Contract test for [endpoint] in [context]/features/[slice_name]/
- [ ] T024 [P] [US3] Integration test for [user journey] in tests/integration/ (when it crosses contexts or runs the whole system; otherwise beside its slice)

### Implementation for User Story 3, one group per slice

#### Slice: [SliceName]

- [ ] T025 [P] [US3] Write [slice] unit tests in [context]/features/[slice_name]/ (they fail first)
- [ ] T026 [US3] Implement [slice] in [context]/features/[slice_name]/, and list it in [context]/apps/[trigger]/

#### Slice: [ConsumerSliceName] (only when the plan's Events table lists this context as a consumer)

- [ ] T027 [P] [US3] Write [consumer slice] tests in [context]/features/[consumer_slice_name]/tests/, including a duplicate delivery that changes nothing (they fail first)
- [ ] T028 [US3] Implement [consumer slice] in [context]/features/[consumer_slice_name]/: consume [EventName] v[N] from its contract, check its idempotency key through the inbox, publish any resulting event through the outbox, and list it in [context]/apps/queue/

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates in docs/
- [ ] TXXX Code cleanup and refactoring
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX [P] Additional unit tests (if requested) in each owner's tests/ folder
- [ ] TXXX Security hardening
- [ ] TXXX Run quickstart.md validation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Slices in the order of the plan's Slice Map, each finished and validated before the next
- Within a slice: its tests, then one task that implements it, including its line in apps/
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Slices within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together (if tests requested):
Task: "Contract test for [endpoint] in [context]/features/[slice_name]/"
Task: "Integration test for [user journey] in tests/integration/"

# Launch independent slices for User Story 1 together:
Task: "Implement [SliceA] in [context]/features/[slice_a]/"
Task: "Implement [SliceB] in [context]/features/[slice_b]/"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
