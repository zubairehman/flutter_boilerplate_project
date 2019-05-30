import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:f_logs/data/local/app_database.dart';
import 'package:sembast/sembast.dart';

class PostDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _postsStore = intMapStoreFactory.store(DBConstants.STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  // Singleton instance
  static final PostDataSource _singleton = PostDataSource._();

  // A private constructor. Allows us to create instances of PostDataSource
  // only from within the PostDataSource class itself.
  PostDataSource._();

  // Singleton accessor
  static PostDataSource get instance => _singleton;

  // DB functions:--------------------------------------------------------------
  Future<int> insert(Post post) async {
    return await _postsStore.add(await _db, post.toMap());
  }

  Future update(Post post) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(post.id));
    await _postsStore.update(
      await _db,
      post.toMap(),
      finder: finder,
    );
  }

  Future delete(Post post) async {
    final finder = Finder(filter: Filter.byKey(post.id));
    await _postsStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _postsStore.drop(
      await _db,
    );
  }

  Future<List<Post>> getAllSortedByFilter({List<Filter> filters}) async {
    //creating finder
    final finder = Finder(
        filter: Filter.and(filters),
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _postsStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final post = Post.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      post.id = snapshot.key;
      return post;
    }).toList();
  }

  Future<List<Post>> getAllPosts() async {
    final recordSnapshots = await _postsStore.find(
      await _db,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final post = Post.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      post.id = snapshot.key;
      return post;
    }).toList();
  }
}