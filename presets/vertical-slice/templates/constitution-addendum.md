<!-- vertical-slice:constitution -->

## Vertical Slice Principles

Place this section after Core Principles and before Governance, and adapt it to the project.

These principles add to Core Principles and replace none of them. Fill the core principle slots as you would without this section, and keep any core principle the user asks to adopt. If a core principle seems to conflict with a principle here, keep both and apply the core principle at context level. For example, a library-first principle means each context is a library.

- **Context, then slice**: Code MUST be organized by bounded context and then by feature slice. Every context MUST use the Project Structure, so every file has one place. Technical-layer folders MUST NOT be the primary structure. A language or a frontend MUST NOT create a context on its own.
- **Slices own shapes**: Each slice owns its request, response, and view models and its tests.
- **Single owner for rules**: A domain rule used by several slices MUST have one owner and MUST NOT be duplicated. When the rule guards state that several slices change, its owner MUST hold that state and its transitions, slices MUST change that state only through the owner, and one transaction MUST change only one owner's state.
- **Contracts between contexts**: Contexts MUST interact only through named shared contracts.
- **Values have one home**: Here a value is config, a credential, a fact a client sees, business data, or an internal constant, not a domain type such as an amount of money. Config, meaning what varies between deploys, MUST come from environment variables, and credentials MUST stay outside the repository. Facts a client sees, such as versions, limits, patterns, and error codes, MUST be declared in the contract document. Business data such as roles and policies MUST live in the store. Only internal values that no client sees and no deploy changes MAY stay in code, each named and defined once.
- **CQRS per context**: Each context MUST record its own decision, defaulting to separate read and write code over one store.
- **One context, one service**: A context MUST stay in one fixed folder however it deploys. When it deploys on its own, it MUST be one service with the context's name, and a service MUST NOT span contexts. Each context MUST own its store, and no other context MAY read or write it. Its `manifest` MUST record its owner, deployment, store, and the events it publishes and consumes.
- **Names say what things do**: Slices MUST be named for what they do, never for what triggers them. Events MUST be named as a noun and a past-tense verb.
- **Outside-in, test-first**: Work MUST start from a skeleton whose checks are proven to fail. Each slice MUST write only the contract it needs, then failing tests, then the minimal code, including only the store schema its tests need. No contract, schema, or shared model MAY be designed ahead of the slice that needs it.
- **Evidence before action**: Decisions MUST be found by progressive distributed disclosure and recorded with their deciding source. Work MUST act only on decisions at 85% confidence or higher; the rest stay open.
- **Checks prove they can fail**: Every check MUST find its targets from the folders, report what it examined, pass on clean code, and fail on a planted violation. Retired names MUST be guarded.
- **Fix the cause**: A failing check MUST be resolved by fixing whichever of the code or the check is wrong, never by weakening the check.
- **Fresh review**: The author MUST NOT review its own work when a fresh reviewer is available.
- **Reliable events**: A published event MUST be a versioned contract written through an outbox in the same transaction as the state change. A consumer MUST be idempotent, recording each message's key in the same transaction as its state change. A process that spans contexts MUST name its pivot, a compensation for every step before the pivot that changes state, and a timeout.
