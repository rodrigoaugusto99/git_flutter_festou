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
      String cep,
      String logradouro,
      String numero,
      String bairro,
      String cidade,
      List<String> selectedTypes,
      List<String> selectedServices,
      List<String> availableDays,
    }) spaceData,
  );
}
