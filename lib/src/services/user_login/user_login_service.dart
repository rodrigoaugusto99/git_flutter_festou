import 'package:festou/src/core/exceptions/service_exception.dart';
import 'package:festou/src/core/fp/either.dart';
import 'package:festou/src/core/fp/nil.dart';

abstract interface class UserLoginService {
  Future<Either<ServiceException, Nil>> execute(String email, String password);
}
