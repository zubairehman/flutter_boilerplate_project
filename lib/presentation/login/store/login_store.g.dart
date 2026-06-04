// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??=
          Computed<bool>(() => super.isLoading, name: '_UserStore.isLoading'))
      .value;

  late final _$isLoggedInAtom =
      Atom(name: '_UserStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$isAuthBootstrappedAtom =
      Atom(name: '_UserStore.isAuthBootstrapped', context: context);

  @override
  bool get isAuthBootstrapped {
    _$isAuthBootstrappedAtom.reportRead();
    return super.isAuthBootstrapped;
  }

  @override
  set isAuthBootstrapped(bool value) {
    _$isAuthBootstrappedAtom.reportWrite(value, super.isAuthBootstrapped, () {
      super.isAuthBootstrapped = value;
    });
  }

  late final _$successAtom = Atom(name: '_UserStore.success', context: context);

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$loginFutureAtom =
      Atom(name: '_UserStore.loginFuture', context: context);

  @override
  ObservableFuture<User?> get loginFuture {
    _$loginFutureAtom.reportRead();
    return super.loginFuture;
  }

  @override
  set loginFuture(ObservableFuture<User?> value) {
    _$loginFutureAtom.reportWrite(value, super.loginFuture, () {
      super.loginFuture = value;
    });
  }

  late final _$bootstrapAuthAsyncAction =
      AsyncAction('_UserStore.bootstrapAuth', context: context);

  @override
  Future<void> bootstrapAuth() {
    return _$bootstrapAuthAsyncAction.run(() => super.bootstrapAuth());
  }

  late final _$loginAsyncAction =
      AsyncAction('_UserStore.login', context: context);

  @override
  Future<void> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isAuthBootstrapped: ${isAuthBootstrapped},
success: ${success},
loginFuture: ${loginFuture},
isLoading: ${isLoading}
    ''';
  }
}
