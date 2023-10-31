import 'dart:io';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

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
  Future<Either<RepositoryException, List<SpaceWithImages>>> getSpacesByType(
      List<String> types);
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSpacesWithSugestion(SpaceWithImages spaceWithImages);
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSurroundingSpaces();
  Future<Either<RepositoryException, List<SpaceWithImages>>> getMySpaces();
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getMyFavoriteSpaces();
  Future<Either<RepositoryException, Nil>> toggleFavoriteSpace(
      String spaceId, bool isFavorited);
}
