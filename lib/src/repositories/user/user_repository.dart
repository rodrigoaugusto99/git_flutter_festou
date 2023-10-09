import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';

abstract interface class UserRepository {
  Future<Either<AuthException, Nil>> login(String email, String password);

  Future<Either<RepositoryException, Nil>> registerUser(
    ({String email, String password}) userData,
  );

  Future<Either<RepositoryException, Nil>> registerUserInfos(() userData);
  Future<Either<RepositoryException, Nil>> registerUserDocument(() userData);
}
