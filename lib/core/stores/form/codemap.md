# lib/core/stores/form/
## Responsibility
MobX stores for form field state and validation: `FormStore` manages email/password/confirm-password inputs and computed readiness flags; `FormErrorStore` tracks per-field validation error messages.

## Design Patterns
- **MobX Code-Gen**: Both `FormStore` and `FormErrorStore` use generated mixin merging.
- **Composition**: `FormStore` owns `FormErrorStore` (field errors) and `ErrorStore` (top-level messages).
- **Reaction-driven Validation**: `_setupValidations()` registers `reaction()` on each field → auto-validates on change.
- **Computed Guards**: `canLogin`, `canRegister`, `canForgetPassword` combine error state + field emptiness checks.

## Data & Control Flow
1. UI calls `setUserId/setPassword/setConfirmPassword` actions.
2. Reactions fire → `validateUserEmail/validatePassword/validateConfirmPassword` → update `FormErrorStore` observables (null = valid).
3. `@computed canLogin/canRegister/canForgetPassword` return `bool` → drive submit button enabled state.
4. `validateAll()` runs all validations at once (e.g., on form submit attempt).
5. `dispose()` tears down all `ReactionDisposer` instances.

## Integration Points
- `ErrorStore` (from `stores/error/`) injected via constructor for top-level error display.
- Consumed by login/register/forgot-password feature screens for reactive form state.