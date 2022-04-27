import 'package:boilerplate/core/data/network/dio/configs/dio_configs.dart';
import 'package:boilerplate/core/data/network/dio/dio_client.dart';
import 'package:boilerplate/core/data/network/dio/interceptors/auth_interceptor.dart';
import 'package:boilerplate/core/data/network/dio/interceptors/logging_interceptor.dart';
import 'package:boilerplate/data/network/apis/posts/post_api.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/interceptors/error_interceptor.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

mixin NetworkModule {
  static Future<void> configureNetworkModuleInjection() async {
    // event bus:---------------------------------------------------------------
    injector.registerSingleton<EventBus>(EventBus());

    // interceptors:------------------------------------------------------------
    injector.registerSingleton<LoggingInterceptor>(LoggingInterceptor());
    injector.registerSingleton<ErrorInterceptor>(ErrorInterceptor(injector()));
    injector.registerSingleton<AuthInterceptor>(
      AuthInterceptor(
        accessToken: () async => await injector<SharedPreferenceHelper>().authToken,
      ),
    );

    // rest client:-------------------------------------------------------------
    injector.registerSingleton(RestClient());

    // dio:---------------------------------------------------------------------
    injector.registerSingleton<DioConfigs>(
      const DioConfigs(
        baseUrl: Endpoints.baseUrl,
        connectionTimeout: Endpoints.connectionTimeout,
        receiveTimeout:Endpoints.receiveTimeout,
      ),
    );
    injector.registerSingleton<DioClient>(
      DioClient(dioConfigs: injector())
        ..addInterceptors(
          [
            injector<AuthInterceptor>(),
            injector<ErrorInterceptor>(),
            injector<LoggingInterceptor>(),
          ],
        ),
    );

    // api's:-------------------------------------------------------------------
    injector.registerSingleton(PostApi(injector<DioClient>(), injector<RestClient>()));
  }
}
