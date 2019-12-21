// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ErrorStore on _ErrorStore, Store {
  final _$errorMessageAtom = Atom(name: '_ErrorStore.errorMessage');

  @override
  String get errorMessage {
    _$errorMessageAtom.context.enforceReadPolicy(_$errorMessageAtom);
    _$errorMessageAtom.reportObserved();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.context.conditionallyRunInAction(() {
      super.errorMessage = value;
      _$errorMessageAtom.reportChanged();
    }, _$errorMessageAtom, name: '${_$errorMessageAtom.name}_set');
  }

  final _$showErrorAtom = Atom(name: '_ErrorStore.showError');

  @override
  bool get showError {
    _$showErrorAtom.context.enforceReadPolicy(_$showErrorAtom);
    _$showErrorAtom.reportObserved();
    return super.showError;
  }

  @override
  set showError(bool value) {
    _$showErrorAtom.context.conditionallyRunInAction(() {
      super.showError = value;
      _$showErrorAtom.reportChanged();
    }, _$showErrorAtom, name: '${_$showErrorAtom.name}_set');
  }
}
