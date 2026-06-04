import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/network/apis/posts/post_api.dart';
import 'package:boilerplate/data/repository/post/post_repository_impl.dart';
import 'package:boilerplate/domain/entity/post/post.dart';
import 'package:boilerplate/domain/entity/post/post_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast.dart';

class _FakePostApi implements PostApi {
  _FakePostApi(this._posts);
  final List<Post> _posts;
  bool failNextCall = false;
  int callCount = 0;

  @override
  Future<PostList> getPosts() async {
    callCount++;
    if (failNextCall) {
      failNextCall = false;
      throw Exception('boom');
    }
    return PostList(posts: List.of(_posts));
  }
}

class _FakePostDataSource implements PostDataSource {
  int insertCount = 0;
  int upsertCount = 0;
  final Map<int, Post> _store = {};

  @override
  Future<int> insert(Post post) async {
    insertCount++;
    _store[post.id] = post;
    return post.id;
  }

  @override
  Future<void> upsert(Post post) async {
    upsertCount++;
    _store[post.id] = post;
  }

  @override
  Future<PostList> getPostsFromDb() async =>
      PostList(posts: _store.values.toList());

  int cachedCount() => _store.length;

  // The other methods are unused in these tests.
  @override
  Future<int> count() async => _store.length;
  @override
  Future<List<Post>> getAllSortedByFilter({List<Filter>? filters}) async =>
      _store.values.toList();
  @override
  Future<int> update(Post post) async => 1;
  @override
  Future<int> delete(Post post) async => 1;
  @override
  Future<void> deleteAll() async {}
}

void main() {
  test('getPosts upserts remote posts into cache once', () async {
    final api = _FakePostApi([Post(userId: 1, id: 1, title: 't', body: 'b')]);
    final ds = _FakePostDataSource();
    final repo = PostRepositoryImpl(api, ds);

    await repo.getPosts();
    await repo.getPosts();

    expect(ds.cachedCount(), 1);
    expect(ds.upsertCount, 2);
  });

  test('getPosts returns cached posts when remote request fails', () async {
    final api = _FakePostApi([Post(userId: 1, id: 1, title: 't', body: 'b')]);
    final ds = _FakePostDataSource();
    final repo = PostRepositoryImpl(api, ds);

    // First call: populates cache.
    await repo.getPosts();
    expect(ds.cachedCount(), 1);

    // Second call: remote will throw, expect cached fallback.
    api.failNextCall = true;
    final posts = await repo.getPosts();

    expect(posts.posts.single.id, 1);
  });
}