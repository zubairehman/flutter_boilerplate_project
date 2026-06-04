# lib/core/data/network/dio/configs/
## Responsibility
Defines `DioConfigs`, an immutable configuration object holding HTTP client settings: base URL, receive timeout, connection timeout.

## Design Patterns
- **Value Object**: `const DioConfigs({...})` is immutable; default timeouts (10 000 ms) provided when omitted.
- **Separation of Config from Client**: Keeps configuration data independent of `DioClient` construction logic.

## Data & Control Flow
- `DioConfigs(baseUrl:, receiveTimeout:, connectionTimeout:)` → passed to `DioClient` constructor.
- Default timeouts (`_kDefaultReceiveTimeout`, `_kDefaultConnectionTimeout` = 10 s) used unless overridden.

## Integration Points
- `DioClient` reads `DioConfigs` fields in its initializer list.
- DI/config modules construct `DioConfigs` using `NetworkConstants` or environment-specific values.