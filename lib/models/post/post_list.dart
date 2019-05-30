import 'package:boilerplate/models/post/post.dart';

class PostsList {
  final List<Post> posts;

  PostsList({
    this.posts,
  });

  factory PostsList.fromJson(List<dynamic> json) {
    List<Post> posts = List<Post>();
    posts = json.map((post) => Post.fromMap(post)).toList();

    return PostsList(
      posts: posts,
    );
  }
}
