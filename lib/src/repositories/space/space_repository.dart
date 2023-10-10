import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';

abstract interface class SpaceRepository {
  Future<Either<RepositoryException, Nil>> save(
    ({
      User user,
      Map<String, dynamic> space,
      List<String> selectedTypes,
      List<String> selectedServices,
      List<String> availableDays,
    }) spaceData,
  );
}
