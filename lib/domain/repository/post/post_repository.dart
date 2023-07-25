import 'dart:async';

import 'package:boilerplate/domain/entity/post/post.dart';
import 'package:boilerplate/domain/entity/post/post_list.dart';

abstract class PostRepository {
  Future<PostList> getPosts();

  Future<List<Post>> findPostById(int id);

  Future<int> insert(Post post);

  Future<int> update(Post post);

  Future<int> delete(Post post);
}
