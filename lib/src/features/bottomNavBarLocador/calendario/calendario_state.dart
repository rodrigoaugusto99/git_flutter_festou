import 'package:git_flutter_festou/src/models/reservation_model.dart';

enum CalendarioReservationsStateStatus { success, error }

class CalendarioReservationsState {
  final CalendarioReservationsStateStatus status;
  final List<ReservationModel> reserva;

  CalendarioReservationsState({
    required this.status,
    required this.reserva,
  });

  CalendarioReservationsState copyWith({
    CalendarioReservationsStateStatus? status,
    List<ReservationModel>? reserva,
  }) {
    return CalendarioReservationsState(
      status: status ?? this.status,
      reserva: reserva ?? this.reserva,
    );
  }
}
