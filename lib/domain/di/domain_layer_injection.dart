import 'package:boilerplate/domain/di/module/usecase_module.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

mixin DomainLayerInjection {
  static Future<void> configureDomainLayerInjection() async {
    await UseCaseModule.configureUseCaseModuleInjection();
  }
}
