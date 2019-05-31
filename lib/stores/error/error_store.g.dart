// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$ErrorStore on _ErrorStore, Store {
  final _$errorMessageAtom = Atom(name: '_ErrorStore.errorMessage');

  @override
  String get errorMessage {
    _$errorMessageAtom.reportObserved();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.context
        .checkIfStateModificationsAreAllowed(_$errorMessageAtom);
    super.errorMessage = value;
    _$errorMessageAtom.reportChanged();
  }

  final _$showErrorAtom = Atom(name: '_ErrorStore.showError');

  @override
  bool get showError {
    _$showErrorAtom.reportObserved();
    return super.showError;
  }

  @override
  set showError(bool value) {
    _$showErrorAtom.context
        .checkIfStateModificationsAreAllowed(_$showErrorAtom);
    super.showError = value;
    _$showErrorAtom.reportChanged();
  }
}
