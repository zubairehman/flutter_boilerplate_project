import 'package:boilerplate/models/post/post.dart';

class PostsList {
  final List<Post> posts;

  PostsList({
    this.posts,
  });

  factory PostsList.fromJson(List<dynamic> json) {
    List<Post> posts = List<Post>();

    return PostsList(
      posts: posts,
    );
  }
}