# lib/data/network/apis/

## Responsibility
Parent directory for API classes organized by domain resource. Each subfolder contains an API class that makes HTTP calls for that resource using `DioClient` and/or `RestClient`.

## Design Patterns
- **API-per-resource**: One API class per domain entity (e.g., `posts/PostApi`), keeping network calls co-located by concern.
- **Dual client injection**: API classes can receive both `DioClient` and `RestClient`, allowing either client for different endpoints.

## Data & Control Flow
API classes receive `DioClient`/`RestClient` via constructor injection → make HTTP requests → deserialize responses into domain entities.

## Integration Points
- `PostApi` — currently the only implementation; calls `Endpoints.getPosts`, returns `PostList`.
- Registered in `NetworkModule` during DI setup.