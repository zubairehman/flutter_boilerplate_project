import 'app_component.dart' as _i1;
import '../modules/local_module.dart' as _i2;
import '../../data/repository.dart' as _i3;
import 'dart:async' as _i4;
import '../modules/netwok_module.dart' as _i5;
import '../../main.dart' as _i6;

class AppComponent$Injector implements _i1.AppComponent {
  AppComponent$Injector._(this._localModule);

  final _i2.LocalModule _localModule;

  _i3.Repository _singletonRepository;

  static _i4.Future<_i1.AppComponent> create(
      _i5.NetworkModule _, _i2.LocalModule localModule) async {
    final injector = AppComponent$Injector._(localModule);

    return injector;
  }

  _i6.MyApp _createMyApp() => _i6.MyApp();
  _i3.Repository _createRepository() =>
      _singletonRepository ??= _localModule.provideRepository();
  @override
  _i6.MyApp get app => _createMyApp();
  @override
  _i3.Repository getRepository() => _createRepository();
}
