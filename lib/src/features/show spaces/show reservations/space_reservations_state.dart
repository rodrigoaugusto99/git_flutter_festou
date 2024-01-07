import 'package:git_flutter_festou/src/models/reservation_model.dart';

enum SpaceReservationsStateStatus { success, error }

class SpaceReservationsState {
  final SpaceReservationsStateStatus status;
  final List<ReservationModel> reserva;

  SpaceReservationsState({
    required this.status,
    required this.reserva,
  });

  SpaceReservationsState copyWith({
    SpaceReservationsStateStatus? status,
    List<ReservationModel>? reserva,
  }) {
    return SpaceReservationsState(
      status: status ?? this.status,
      reserva: reserva ?? this.reserva,
    );
  }
}
