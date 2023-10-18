import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/service_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/repositories/user/user_auth_repository.dart';
import 'package:git_flutter_festou/src/repositories/user/user_firestore_repository.dart';

import 'package:git_flutter_festou/src/services/user_login/user_login_service.dart';
import './user_register_service.dart';

class UserRegisterServiceImpl implements UserRegisterService {
  final UserAuthRepository userAuthRepository;
  final UserFirestoreRepository userFirestoreRepository;
  final UserLoginService userLoginService;

  UserRegisterServiceImpl({
    required this.userAuthRepository,
    required this.userLoginService,
    required this.userFirestoreRepository,
  });
  @override
  Future<Either<ServiceException, Nil>> execute(
      ({
        String email,
        String password,
      }) userData) async {
    final registerAuthResult = await userAuthRepository.registerUser(userData);

    /*agora, além do auth, aqui também é chamado 
    o método de criar usuario no firestore*/
    //todo: registerFirestoreResult entrar no switch
    final user = FirebaseAuth.instance.currentUser!;
    final registerFirestoreResult =
        await userFirestoreRepository.createUserInFirestore(user);

    switch (registerAuthResult) {
      case Success():
        final result =
            userLoginService.execute(userData.email, userData.password);
        return result;
      case Failure(:final exception):
        return Failure(ServiceException(message: exception.message));
    }
  }
}
