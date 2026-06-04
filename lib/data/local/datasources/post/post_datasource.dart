import 'package:boilerplate/core/data/local/sembast/sembast_client.dart';
import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/data/mapper/post_mapper.dart';
import 'package:boilerplate/data/network/dto/post_dto.dart';
import 'package:boilerplate/domain/entity/post/post.dart';
import 'package:boilerplate/domain/entity/post/post_list.dart';
import 'package:sembast/sembast.dart';

class PostDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _postsStore = intMapStoreFactory.store(DBConstants.storeName);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  //  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final SembastClient _sembastClient;

  // Constructor
  PostDataSource(this._sembastClient);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(Post post) async {
    return await _postsStore.add(_sembastClient.database, post.toDto().toJson());
  }

  Future<void> upsert(Post post) async {
    final finder = Finder(filter: Filter.equals(DBConstants.fieldId, post.id));
    final existing = await _postsStore.findFirst(
      _sembastClient.database,
      finder: finder,
    );
    if (existing == null) {
      await insert(post);
    } else {
      await _postsStore.record(existing.key).update(
        _sembastClient.database,
        post.toDto().toJson(),
      );
    }
  }

  Future<int> count() async {
    return await _postsStore.count(_sembastClient.database);
  }

  Future<List<Post>> getAllSortedByFilter({List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.fieldId)]);

    final recordSnapshots = await _postsStore.find(
      _sembastClient.database,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final dto = PostDto.fromJson(snapshot.value);
      return dto.toDomain();
    }).toList();
  }

  Future<PostList> getPostsFromDb() async {
    // fetching data
    final recordSnapshots = await _postsStore.find(
      _sembastClient.database,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return PostList(
      posts: recordSnapshots.map((snapshot) {
        final dto = PostDto.fromJson(snapshot.value);
        return dto.toDomain();
      }).toList(),
    );
  }

  Future<int> update(Post post) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(post.id));
    return await _postsStore.update(
      _sembastClient.database,
      post.toDto().toJson(),
      finder: finder,
    );
  }

  Future<int> delete(Post post) async {
    final finder = Finder(filter: Filter.byKey(post.id));
    return await _postsStore.delete(
      _sembastClient.database,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _postsStore.drop(
      _sembastClient.database,
    );
  }
}