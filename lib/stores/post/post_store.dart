import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';

part 'post_store.g.dart';

class PostStore = _PostStore with _$PostStore;

abstract class _PostStore implements Store {

  // store for handling errors
  final ErrorStore error = ErrorStore();

  // store variables:-----------------------------------------------------------
  @observable
  PostsList postsList;

  @observable
  bool success = false;

  @observable
  bool loading = false;

  // actions:-------------------------------------------------------------------
  @action
  Future getPosts() async {
    loading = true;

    Repository.instance.getPosts().then((postsList) {
      this.postsList = postsList;
      loading = false;
      success = true;
      error.showError = false;
    }).catchError((e) {
      loading = false;
      success = false;
      error.showError = true;
      error.errorMessage =
      "Something went wrong, please check your internet connection and try again";
      print(e);
    });
  }
}