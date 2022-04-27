import 'dart:async';

import 'package:boilerplate/domain/repository/post/post_repository.dart';
import 'package:boilerplate/domain/usecase/post/delete_post_usecase.dart';
import 'package:boilerplate/domain/usecase/post/find_post_by_id_usecase.dart';
import 'package:boilerplate/domain/usecase/post/get_post_usecase.dart';
import 'package:boilerplate/domain/usecase/post/insert_post_usecase.dart';
import 'package:boilerplate/domain/usecase/post/udpate_post_usecase.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

mixin UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    injector.registerSingleton<GetPostUseCase>(
      GetPostUseCase(injector<PostRepository>()),
    );
    injector.registerSingleton<FindPostByIdUseCase>(
      FindPostByIdUseCase(injector<PostRepository>()),
    );
    injector.registerSingleton<InsertPostUseCase>(
      InsertPostUseCase(injector<PostRepository>()),
    );
    injector.registerSingleton<UpdatePostUseCase>(
      UpdatePostUseCase(injector<PostRepository>()),
    );
    injector.registerSingleton<DeletePostUseCase>(
      DeletePostUseCase(injector<PostRepository>()),
    );
  }
}
