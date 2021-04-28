import 'package:boilerplate/models/post/post.dart';

class PostList {
  final List<Post>? posts;

  PostList({
    this.posts,
  });

  factory PostList.fromJson(List<dynamic> json) {
    List<Post> posts = <Post>[];
    posts = json.map((post) => Post.fromMap(post)).toList();

    return PostList(
      posts: posts,
    );
  }
}
