import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';

abstract interface class ReservationFirestoreRepository {
  Future<Either<RepositoryException, Nil>> saveReservation(
    ({
      String userId,
      String spaceId,
      String range,
    }) reservationData,
  );

  Future<Either<RepositoryException, List<ReservationModel>>> getReservations(
      String spaceId);

  Future<Either<RepositoryException, List<ReservationModel>>>
      getMyReservedClients();
}
