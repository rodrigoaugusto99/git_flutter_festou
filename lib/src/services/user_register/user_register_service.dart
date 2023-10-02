import 'package:git_flutter_festou/src/core/exceptions/service_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';

abstract interface class UserRegisterService {
  Future<Either<ServiceException, Nil>> execute(
      ({String email, String password}) userData);
}
