import 'package:mobx/mobx.dart';

part 'error_store.g.dart';

class ErrorStore = _ErrorStore with _$ErrorStore;

abstract class _ErrorStore with Store {

  // store variables:-----------------------------------------------------------
  @observable
  String errorMessage;

  @observable
  bool showError = false;
}