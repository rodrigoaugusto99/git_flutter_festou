import 'dart:io';
import 'package:Festou/src/core/exceptions/repository_exception.dart';
import 'package:Festou/src/core/fp/either.dart';
import 'package:Festou/src/core/fp/nil.dart';
import 'package:Festou/src/models/space_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      List<File> videoFiles,
      String descricao,
      String preco,
      double latitude,
      double longitude,
      Days days,
      //  String cnpjEmpresaLocadora,
      String estado,
      // String locadorCpf,
      // String nomeEmpresaLocadora,
      // String locadorAssinatura,
    }) spaceData,
  );

  Future<Either<RepositoryException, List<SpaceModel>>> getAllSpaces();
  Future<Either<RepositoryException, List<SpaceModel>>> getSpacesByType(
      List<String> types);
  Future<Either<RepositoryException, List<SpaceModel>>> getSugestions(
      SpaceModel spaceModel);
  Future<Either<RepositoryException, List<SpaceModel>>> getSurroundingSpaces(
      LatLngBounds visibleRegion);
  Future<Either<RepositoryException, List<SpaceModel>>> getMySpaces();

  Future<Either<RepositoryException, List<SpaceModel>>>
      getSpacesBySelectedTypes({
    List<String> selectedTypes,
  });
  Future<Either<RepositoryException, List<SpaceModel>>>
      getSpacesBySelectedServices({
    List<String> selectedServices,
  });
  Future<Either<RepositoryException, List<SpaceModel>>>
      getSpacesByAvailableDays({
    List<String> availableDays,
  });

  Future<Either<RepositoryException, List<SpaceModel>>> filterSpaces(
    List<SpaceModel> spaces1,
    List<SpaceModel> spaces2,
    List<SpaceModel> spaces3,
  );

  Future<Either<RepositoryException, List<SpaceModel>>> getMyFavoriteSpaces();
  Future<Either<RepositoryException, Nil>> toggleFavoriteSpace(
      String spaceId, bool isFavorited);
}
