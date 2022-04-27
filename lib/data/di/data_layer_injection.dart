import 'package:boilerplate/data/di/module/local_module.dart';
import 'package:boilerplate/data/di/module/network_module.dart';
import 'package:boilerplate/data/di/module/repository_module.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

mixin DataLayerInjection {
  static Future<void> configureDataLayerInjection() async {
    await LocalModule.configureLocalModuleInjection();
    await NetworkModule.configureNetworkModuleInjection();
    await RepositoryModule.configureRepositoryModuleInjection();
  }
}
