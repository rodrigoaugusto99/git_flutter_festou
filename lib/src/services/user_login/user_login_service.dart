import 'package:Festou/src/core/exceptions/service_exception.dart';
import 'package:Festou/src/core/fp/either.dart';
import 'package:Festou/src/core/fp/nil.dart';

abstract interface class UserLoginService {
  Future<Either<ServiceException, Nil>> execute(String email, String password);
}
