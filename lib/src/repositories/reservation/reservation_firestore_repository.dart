import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';

abstract interface class ReservationFirestoreRepository {
  Future<Either<RepositoryException, Nil>> saveReservation(
    ({
      String userId,
      String reservationId,
      String range,
    }) reservationData,
  );
}
