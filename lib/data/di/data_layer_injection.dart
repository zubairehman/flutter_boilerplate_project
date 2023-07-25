import 'package:boilerplate/data/di/module/local_module.dart';
import 'package:boilerplate/data/di/module/network_module.dart';
import 'package:boilerplate/data/di/module/repository_module.dart';

mixin DataLayerInjection {
  static Future<void> configureDataLayerInjection() async {
    await LocalModule.configureLocalModuleInjection();
    await NetworkModule.configureNetworkModuleInjection();
    await RepositoryModule.configureRepositoryModuleInjection();
  }
}
