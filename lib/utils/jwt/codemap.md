# lib/utils/jwt/

## Responsibility

Provides JWT signing, verification, and decoding utilities wrapping `package:dart_jsonwebtoken`.

## Design Patterns

- **Static-only class**: `JwtHelper._()` prevents instantiation; all public methods are static.
- **Safe-by-default**: `tryVerify()` and `tryDecode()` use the `try*` variants from `dart_jsonwebtoken`, returning `null` instead of throwing on invalid tokens.
- **Normalized claims**: `_claimsFromPayload()` coerces `payload` keys to `String`, ensuring the return type is always `Map<String, dynamic>?` regardless of how the JWT library represents the payload internally.

## Data & Control Flow

1. `JwtHelper.sign(claims, secret: …)` → constructs `JWT` with optional `issuer`/`audience`/`subject` → wraps audience via `_audience()` → signs with `SecretKey(secret)` and `expiresIn` → returns token `String`
2. `JwtHelper.tryVerify(token, secret: …)` → calls `JWT.tryVerify()` with `SecretKey` and optional claim validators → extracts claims via `_claimsFromPayload()` → returns `Map<String, dynamic>?` (`null` if verification fails)
3. `JwtHelper.tryDecode(token)` → calls `JWT.tryDecode()` (no signature check) → extracts claims via `_claimsFromPayload()` → returns `Map<String, dynamic>?` (`null` if decoding fails)

## Integration Points

- `package:dart_jsonwebtoken` — `JWT`, `SecretKey`, `Audience` for token creation and verification
- `lib/data/` — likely consumer for auth token generation and validation (signs tokens on login, verifies on request intercept)