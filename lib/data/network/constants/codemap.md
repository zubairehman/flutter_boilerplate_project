# lib/data/network/constants/

## Responsibility
Defines `Endpoints` — static constants for the base URL, timeouts, and API route paths used by network clients and API classes.

## Design Patterns
- **Constants class**: Private constructor prevents instantiation; all members are `static const`.

## Data & Control Flow
- `Endpoints.baseUrl` → consumed by `DioConfigs` in `NetworkModule`.
- `Endpoints.getPosts` → consumed by `PostApi.getPosts()`.
- `Endpoints.receiveTimeout` / `connectionTimeout` → consumed by `DioConfigs`.

## Integration Points
- `lib/data/network/apis/posts/post_api.dart` — uses `Endpoints.getPosts`.
- `lib/data/di/module/network_module.dart` — uses `Endpoints.baseUrl`, timeout values to construct `DioConfigs`.