import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';

abstract interface class SpaceFirestoreRepository {
  Future<Either<RepositoryException, Nil>> saveSpace(
    ({
      String spaceId,
      String userId,
      String email,
      String name,
    }) spaceData,
  );
  Future<Either<RepositoryException, Nil>> saveSpaceAddress(
    ({
      String cep,
      String logradouro,
      String numero,
      String bairro,
      String cidade,
      String spaceId,
    }) spaceAddressData,
  );
  Future<Either<RepositoryException, Nil>> saveSpaceInfos(
    ({
      List<String> selectedTypes,
      List<String> selectedServices,
      List<String> availableDays,
      String spaceId
    }) spaceInfosData,
  );
}
