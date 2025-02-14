import 'package:festou/src/core/exceptions/service_exception.dart';
import 'package:festou/src/core/fp/either.dart';
import 'package:festou/src/core/fp/nil.dart';
import 'package:festou/src/repositories/user/user_auth_repository.dart';
import 'package:festou/src/repositories/user/user_firestore_repository.dart';
import 'package:festou/src/services/user_login/user_login_service.dart';
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
        String name,
        String cpf,
      }) userData) async {
    final registerAuthResult = await userAuthRepository.registerUser(userData);

    /*agora, além do auth, aqui também é chamado 
    o método de criar usuario no firestore*/

    switch (registerAuthResult) {
      case Success(value: final userCredential):
        final user = userCredential.user!;

        final userDataFirestore = (
          id: user.uid,
          email: userData.email,
          name: userData.name,
          cpf: userData.cpf,
        );
        //só salvar no firestore se salvar no auth

        await userFirestoreRepository.saveUser(userDataFirestore);
        final result =
            userLoginService.execute(userData.email, userData.password);
        return result;
      case Failure(:final exception):
        return Failure(ServiceException(message: exception.message));
    }
  }
}
