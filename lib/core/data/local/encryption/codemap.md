# lib/core/data/local/encryption/
## Responsibility
Provides XXTEA-based encryption codec for Sembast database encryption. Implements `dart:convert` `Codec<Map<String, dynamic>, String>` for transparent encode/decode.

## Design Patterns
- **Codec Pattern**: `_XXTeaCodec` composes `_XXTeaEncoder` and `_XXTeaDecoder`, both extending `Converter`.
- **Factory Function**: `getXXTeaCodec(password:)` returns a `SembastCodec` with signature `'xxtea'`, directly usable by `databaseFactory.openDatabase(codec:)`.

## Data & Control Flow
1. `getXXTeaCodec(password:)` → creates `_XXTeaCodec(password)`.
2. **Write path**: `Map<String, dynamic>` → `_XXTeaEncoder.convert()` → `json.encode` → `xxtea.encryptToString` → encrypted `String`.
3. **Read path**: encrypted `String` → `_XXTeaDecoder.convert()` → `xxtea.decryptToString` → `json.decode` → `Map<String, dynamic>`.

## Integration Points
- Called by `SembastClient.provideDatabase()` in `data/local/sembast/sembast_client.dart`.
- Depends on `package:xxtea` and `package:sembast` (for `SembastCodec` type).