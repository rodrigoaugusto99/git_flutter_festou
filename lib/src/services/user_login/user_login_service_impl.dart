import 'package:git_flutter_festou/src/core/exceptions/service_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/repositories/user/user_auth_repository.dart';
import './user_login_service.dart';

class UserLoginServiceImpl implements UserLoginService {
  final UserAuthRepository userAuthRepository;

  UserLoginServiceImpl({required this.userAuthRepository});
  @override
  Future<Either<ServiceException, Nil>> execute(
      String email, String password) async {
    final loginResult = await userAuthRepository.login(email, password);

    switch (loginResult) {
      case Success():
        return Success(nil);
      case Failure():
        return Failure(ServiceException(message: 'Erro ao realizar login'));
    }
  }
}
