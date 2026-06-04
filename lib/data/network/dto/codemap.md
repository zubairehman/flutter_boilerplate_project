# lib/data/network/dto/

## Responsibility
Defines Data Transfer Objects (DTOs) — plain data classes that mirror the JSON structure of API responses. Each DTO has `fromJson`/`toJson` for serialization and is converted to/from domain entities via mappers in `lib/data/mapper/`.

## Design Patterns
- **DTO pattern**: DTOs are data-only classes with no business logic; they exist purely to represent wire-format JSON.
- **Factory constructor**: `fromJson` factory constructors handle JSON → DTO deserialization.
- **Symmetric serialization**: `toJson()` produces `Map<String, dynamic>` matching the API contract.

## Data & Control Flow
- API response JSON → `PostDto.fromJson(json)` → `PostDto` → `PostDto.toDomain()` → `Post` (via mapper extension).
- Domain entity `Post` → `Post.toDto()` → `PostDto` → `PostDto.toJson()` → Sembast storage map.

## Integration Points
- `lib/data/mapper/post_mapper.dart` — extension methods that convert between `PostDto` and `Post`.
- `lib/data/network/apis/posts/post_api.dart` — deserializes API response into `PostDto` list.
- `lib/data/local/datasources/post/post_datasource.dart` — uses `PostDto.fromJson` and `PostDto.toJson` for local DB read/write.