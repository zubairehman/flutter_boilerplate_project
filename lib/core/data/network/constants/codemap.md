# lib/core/data/network/constants/
## Responsibility
Centralizes network configuration constants: base API URL, receive timeout, and connection timeout.

## Design Patterns
- **Static Constants Class**: `NetworkConstants._()` private constructor prevents instantiation; all fields are `static const`.

## Data & Control Flow
- `NetworkConstants.baseUrl` → used as default in `DioConfigs` or overridden per environment.
- `NetworkConstants.receiveTimeout` (15 000 ms) and `connectionTimeout` (30 000 ms) → inform `DioClient` timeout settings.

## Integration Points
- Referenced by DI/config modules to construct `DioConfigs` passed to `DioClient`.