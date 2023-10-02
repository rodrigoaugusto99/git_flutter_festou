import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<Either<AuthException, Nil>> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<RepositoryException, Nil>> registerUser(
      ({String email, String password}) userData) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}
