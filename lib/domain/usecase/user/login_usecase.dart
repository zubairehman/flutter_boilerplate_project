import '../../../core/domain/usecase/use_case.dart';
import '../../entity/user/user.dart';
import '../../repository/user/user_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_usecase.g.dart';

@JsonSerializable()
class LoginParams {
  final String username;
  final String password;

  LoginParams({required this.username, required this.password});

  factory LoginParams.fromJson(Map<String, dynamic> json) =>
      _$LoginParamsFromJson(json);

  Map<String, dynamic> toJson() => _$LoginParamsToJson(this);
}

class LoginUseCase implements UseCase<User?, LoginParams> {
  final UserRepository _userRepository;

  LoginUseCase(this._userRepository);

  @override
  Future<User?> call({required LoginParams params}) async {
    return _userRepository.login(params);
  }
}