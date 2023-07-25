import 'package:boilerplate/core/stores/error/error_store.dart';
import 'package:boilerplate/domain/entity/post/post_list.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/usecase/post/get_post_usecase.dart';

part 'post_store.g.dart';

class PostStore = _PostStore with _$PostStore;

abstract class _PostStore with Store {
  // constructor:---------------------------------------------------------------
  _PostStore(this._getPostUseCase, this.errorStore);

  // use cases:-----------------------------------------------------------------
  final GetPostUseCase _getPostUseCase;

  // stores:--------------------------------------------------------------------
  // store for handling errors
  final ErrorStore errorStore;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<PostList?> emptyPostResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<PostList?> fetchPostsFuture =
      ObservableFuture<PostList?>(emptyPostResponse);

  @observable
  PostList? postList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchPostsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getPosts() async {
    final future = _getPostUseCase.call(params: null);
    fetchPostsFuture = ObservableFuture(future);

    future.then((postList) {
      this.postList = postList;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
