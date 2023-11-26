import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';

abstract interface class UserAuthRepository {
  Future<Either<AuthException, Nil>> login(String email, String password);

  //Future<Either<AuthException, Nil>> loginWithGoogle();

  Future<Either<AuthException, UserCredential>> registerUser(
    ({String email, String password}) userData,
  );
}
