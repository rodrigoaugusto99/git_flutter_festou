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
      String titulo,
      String cep,
      String logradouro,
      String numero,
      String bairro,
      String cidade,
      List<String> selectedTypes,
      List<String> selectedServices,
      List<File> imageFiles,
      String descricao,
      String city,
    }) spaceData,
  );

  Future<Either<RepositoryException, List<SpaceWithImages>>> getAllSpaces();
  Future<Either<RepositoryException, List<SpaceWithImages>>> getSpacesByType(
      List<String> types);
  Future<Either<RepositoryException, List<SpaceWithImages>>> getSugestions(
      SpaceWithImages spaceWithImages);
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSurroundingSpaces();
  Future<Either<RepositoryException, List<SpaceWithImages>>> getMySpaces();

  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSpacesBySelectedTypes({
    List<String> selectedTypes,
  });
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSpacesBySelectedServices({
    List<String> selectedServices,
  });
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSpacesByAvailableDays({
    List<String> availableDays,
  });

  Future<Either<RepositoryException, List<SpaceWithImages>>> filterSpaces(
    List<SpaceWithImages> spaces1,
    List<SpaceWithImages> spaces2,
    List<SpaceWithImages> spaces3,
  );

  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getMyFavoriteSpaces();
  Future<Either<RepositoryException, Nil>> toggleFavoriteSpace(
      String spaceId, bool isFavorited);
}
