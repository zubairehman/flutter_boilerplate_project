# lib/core/data/local/
## Responsibility
Local data infrastructure: Sembast NoSQL database client and XXTEA encryption codec for database-level encryption. Supports both native and web platforms.

## Design Patterns
- **Strategy via Codec**: XXTEA encryption is injected as a `SembastCodec` at database open time — transparent to callers.
- **Platform-aware Factory**: `SembastClient` selects `databaseFactoryIo` vs `databaseFactoryWeb` based on `kIsWeb`.

## Data & Control Flow
1. `SembastClient.provideDatabase(databaseName, databasePath, encryptionKey)` opens DB.
2. If `encryptionKey` is non-empty → `getXXTeaCodec(password:)` wraps DB with XXTEA `SembastCodec`.
3. Platform check (`kIsWeb`) selects IO vs Web factory.
4. Returns `SembastClient` exposing `Database` for feature repositories to query.

## Integration Points
- `encryption/xxtea.dart` → `SembastClient.provideDatabase()` for `SembastCodec`.
- `sembast/sembast_client.dart` → feature repository implementations and DI module.

| Directory | Responsibility |
|-----------|---------------|
| `encryption/` | XXTEA codec for Sembast database encryption |
| `sembast/` | Sembast NoSQL database client with optional encryption |