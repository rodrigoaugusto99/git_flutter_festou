import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';

import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

abstract interface class UserFirestoreRepository {
  //Future<Either<RepositoryException, Nil>> saveUserWithGoogle();
  Future<Either<RepositoryException, Nil>> saveUser(
      ({String id, String email, String name, String cpf}) userData);

  Future<Either<RepositoryException, Nil>> deleteUserDocument(User user);
  Future<Either<RepositoryException, Nil>> saveUserInfos(
      ({
        String userId,
        String name,
        String telefone,
        String cep,
        String logradouro,
        String bairro,
        String cidade,
      }) userData);

  Future<Either<RepositoryException, UserModel>> getUser();

  Future<Either<RepositoryException, Nil>> updatetUser(
      String text, String newText);

  Future<Either<RepositoryException, UserModel>> getUserById(String userId);

  Future<Either<RepositoryException, Nil>> clearField(
      String fieldName, String userId);
}
