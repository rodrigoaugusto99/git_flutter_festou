import 'dart:io';

import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';
import 'package:git_flutter_festou/src/repositories/images/images_storage_repository.dart';

abstract interface class SpaceFirestoreRepository {
  Future<Either<RepositoryException, Nil>> saveSpace(
    ({
      String spaceId,
      String userId,
      String email,
      String name,
      String cep,
      String logradouro,
      String numero,
      String bairro,
      String cidade,
      List<String> selectedTypes,
      List<String> selectedServices,
      List<String> availableDays,
      List<File> imageFiles,
    }) spaceData,
  );

  Future<Either<RepositoryException, List<SpaceWithImages>>> getAllSpaces();
  Future<Either<RepositoryException, List<SpaceWithImages>>> getMySpaces();
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getMyFavoriteSpaces();
  Future<Either<RepositoryException, Nil>> toggleFavoriteSpace(
      String spaceId, bool isFavorited);
}
