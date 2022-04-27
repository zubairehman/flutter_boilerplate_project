import 'package:boilerplate/core/data/local/encryption/xxtea.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastClient {
  final Database _database;

  SembastClient(this._database);

  Database get database => _database;

  static Future<SembastClient> provideDatabase({
    String encryptionKey = '',
    required String databaseName,
    required String databasePath,
  }) async {
    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(databasePath, databaseName);

    // Check to see if encryption is set, then provide codec
    // else init normal db with path
    // Database database;
    final database;
    if (encryptionKey.isNotEmpty) {
      // Initialize the encryption codec with a user password
      var codec = getXXTeaCodec(password: encryptionKey);
      database = await databaseFactoryIo.openDatabase(dbPath, codec: codec);
    } else {
      database = await databaseFactoryIo.openDatabase(dbPath);
    }

    // Return database instance
    return SembastClient(database);
  }
}
