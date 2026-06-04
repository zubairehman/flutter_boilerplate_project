# lib/core/stores/error/
## Responsibility
MobX store for displaying transient error messages. Auto-clears `errorMessage` 200ms after being set via a MobX reaction.

## Design Patterns
- **MobX Code-Gen**: `ErrorStore = _ErrorStore with _$ErrorStore`; `@observable errorMessage`, `@action setErrorMessage()`, `@action reset()`.
- **Self-clearing Observable**: `reaction((_) => errorMessage, reset, delay: 200)` ensures error messages auto-dismiss, enabling brief toast/snackbar display.

## Data & Control Flow
1. Caller invokes `setErrorMessage("…")` → `errorMessage` updated.
2. MobX reaction fires after 200ms delay → `reset()` sets `errorMessage = ''`.
3. UI `Observer` widgets react to `errorMessage` changes for display/hide.

## Integration Points
- Injected into `FormStore` constructor for form-level error display.
- Used directly by feature ViewModels for network/operation error presentation.