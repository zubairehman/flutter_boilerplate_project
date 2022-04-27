import 'package:boilerplate/presentation/di/module/store_module.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

mixin PresentationLayerInjection {
  static Future<void> configurePresentationLayerInjection() async {
    await StoreModule.configureStoreModuleInjection();
  }
}
