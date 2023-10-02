import 'package:git_flutter_festou/src/core/exceptions/service_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/repositories/user/user_repository.dart';
import 'package:git_flutter_festou/src/services/user_login/user_login_service.dart';
import './user_register_service.dart';

class UserRegisterServiceImpl implements UserRegisterService {
  final UserRepository userRepository;
  final UserLoginService userLoginService;

  UserRegisterServiceImpl(
      {required this.userRepository, required this.userLoginService});
  @override
  Future<Either<ServiceException, Nil>> execute(
      ({
        String email,
        String password,
      }) userData) async {
    final registerResult = await userRepository.registerUser(userData);

    switch (registerResult) {
      case Success():
        return userLoginService.execute(userData.email, userData.password);
      case Failure(:final exception):
        return Failure(ServiceException(message: exception.message));
    }
  }
}
