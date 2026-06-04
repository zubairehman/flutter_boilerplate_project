// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsStore on _SettingsStore, Store {
  late final _$_aboutInfoAtom =
      Atom(name: '_SettingsStore._aboutInfo', context: context);

  @override
  String? get _aboutInfo {
    _$_aboutInfoAtom.reportRead();
    return super._aboutInfo;
  }

  @override
  set _aboutInfo(String? value) {
    _$_aboutInfoAtom.reportWrite(value, super._aboutInfo, () {
      super._aboutInfo = value;
    });
  }

  late final _$_loadingAtom =
      Atom(name: '_SettingsStore._loading', context: context);

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: '_SettingsStore._errorMessage', context: context);

  @override
  String? get _errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$loadAboutInfoAsyncAction =
      AsyncAction('_SettingsStore.loadAboutInfo', context: context);

  @override
  Future<void> loadAboutInfo() {
    return _$loadAboutInfoAsyncAction.run(() => super.loadAboutInfo());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
