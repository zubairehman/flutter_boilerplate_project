// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

part 'error_store.g.dart';

class ErrorStore = _ErrorStore with _$ErrorStore;

abstract class _ErrorStore with Store {
  // disposers
  late List<ReactionDisposer> _disposers;

  // constructor:---------------------------------------------------------------
  _ErrorStore() {
    _disposers = [
      reaction((_) => errorMessage, reset, delay: 200),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String errorMessage = '';

  // actions:-------------------------------------------------------------------
  @action
  void setErrorMessage(String message) {
    errorMessage = message;
  }

  @action
  void reset(String value) {
    errorMessage = '';
  }

  // dispose:-------------------------------------------------------------------
  @action
  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
  }
}
