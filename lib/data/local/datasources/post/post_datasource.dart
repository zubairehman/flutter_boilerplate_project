class PostDataSource {
  // singleton object
  static final PostDataSource _postDataSource =
  PostDataSource._internal();

  // named private constructor
  PostDataSource._internal();

  // factory method to return the same object each time its needed
  factory PostDataSource() => _postDataSource;

}