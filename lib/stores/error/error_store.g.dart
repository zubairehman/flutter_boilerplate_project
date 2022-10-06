// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ErrorStore on _ErrorStore, Store {
  final _$errorMessageAtom = Atom(name: '_ErrorStore.errorMessage');

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  final _$_ErrorStoreActionController = ActionController(name: '_ErrorStore');

  @override
  void setErrorMessage(String message) {
    final _$actionInfo = _$_ErrorStoreActionController.startAction(
        name: '_ErrorStore.setErrorMessage');
    try {
      return super.setErrorMessage(message);
    } finally {
      _$_ErrorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset(String value) {
    final _$actionInfo =
        _$_ErrorStoreActionController.startAction(name: '_ErrorStore.reset');
    try {
      return super.reset(value);
    } finally {
      _$_ErrorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic dispose() {
    final _$actionInfo =
        _$_ErrorStoreActionController.startAction(name: '_ErrorStore.dispose');
    try {
      return super.dispose();
    } finally {
      _$_ErrorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
errorMessage: ${errorMessage}
    ''';
  }
}
