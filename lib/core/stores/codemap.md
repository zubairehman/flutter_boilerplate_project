# lib/core/stores/
## Responsibility
MobX reactive state management stores: form validation state (`FormStore`) and error message display (`ErrorStore`). Provide observable state and actions that UI widgets react to via `Observer`.

## Design Patterns
- **MobX Code-Gen**: Store classes use `Store = _Store with _$Store` mixin merging; `@observable`, `@action`, `@computed` annotations drive code generation.
- **Composition**: `FormStore` composes `FormErrorStore` and `ErrorStore` for separation of field-level errors vs. top-level error messages.
- **Reaction-based Validation**: `_setupValidations()` registers MobX `reaction()` disposers that auto-validate fields on change.

## Data & Control Flow
1. UI inputs call `FormStore.setUserId()`, `setPassword()`, `setConfirmPassword()`.
2. MobX reactions fire → `validateUserEmail/password/confirmPassword` → update `FormErrorStore` observables.
3. `@computed canLogin/canRegister/canForgetPassword` derive button-enable state from error + emptiness checks.
4. `ErrorStore.setErrorMessage()` → auto-resets after 200ms via MobX `reaction` with `delay: 200`.

## Integration Points
- `FormStore` → consumed by login/register/forgot-password screen ViewModels.
- `ErrorStore` → consumed by any screen needing transient error display (snackbars, dialogs).
- Stores injected via DI and disposed via `dispose()` in lifecycle management.

| Directory | Responsibility |
|-----------|---------------|
| `form/` | `FormStore` + `FormErrorStore` for form field state, validation, and computed readiness flags |
| `error/` | `ErrorStore` for transient error message display with auto-reset |