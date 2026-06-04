# lib/core/data/local/sembast/
## Responsibility
Provides `SembastClient`, the database accessor for Sembast NoSQL storage. Handles platform-aware database initialization with optional XXTEA encryption.

## Design Patterns
- **Factory Constructor**: `SembastClient.provideDatabase()` is a static async factory that abstracts platform (web vs native), path resolution, and optional encryption codec injection.
- **Platform Strategy**: Uses `kIsWeb` to branch between `databaseFactoryWeb` and `databaseFactoryIo`.

## Data & Control Flow
1. Caller provides `databaseName`, `databasePath`, optional `encryptionKey`.
2. `join(databasePath, databaseName)` resolves native file path.
3. If `encryptionKey.isNotEmpty` → `getXXTeaCodec(password: encryptionKey)` → opens DB with codec.
4. If `kIsWeb` → uses `databaseFactoryWeb`; else `databaseFactoryIo.openDatabase(dbPath)`.
5. Returns `SembastClient(database)` wrapping the opened `Database`.

## Integration Points
- `encryption/xxtea.dart` → `getXXTeaCodec()` for encrypted DB opening.
- Feature DI modules → instantiate `SembastClient` and inject `Database` into repositories.