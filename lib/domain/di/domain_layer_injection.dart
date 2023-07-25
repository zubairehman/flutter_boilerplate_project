import 'package:boilerplate/domain/di/module/usecase_module.dart';

mixin DomainLayerInjection {
  static Future<void> configureDomainLayerInjection() async {
    await UseCaseModule.configureUseCaseModuleInjection();
  }
}
