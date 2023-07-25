import '../../../core/domain/usecase/use_case.dart';
import '../../repository/user/user_repository.dart';

class SaveLoginStatusUseCase implements UseCase<void, bool> {
  final UserRepository _userRepository;

  SaveLoginStatusUseCase(this._userRepository);

  @override
  Future<void> call({required bool params}) async {
    return _userRepository.saveIsLoggedIn(params);
  }
}