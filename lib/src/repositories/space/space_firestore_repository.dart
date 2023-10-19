import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

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

  Future<Either<RepositoryException, List<SpaceModel>>> getAllSpaces();
}
