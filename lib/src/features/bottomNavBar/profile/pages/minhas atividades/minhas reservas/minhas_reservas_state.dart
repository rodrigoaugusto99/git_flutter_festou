import 'package:git_flutter_festou/src/models/reservation_model.dart';

enum MinhasReservasStateStatus { success, error }

class MinhasReservasState {
  final MinhasReservasStateStatus status;
  final List<ReservationModel> reservas;

  MinhasReservasState({
    required this.status,
    required this.reservas,
  });

  MinhasReservasState copyWith({
    MinhasReservasStateStatus? status,
    List<ReservationModel>? reservas,
  }) {
    return MinhasReservasState(
      status: status ?? this.status,
      reservas: reservas ?? this.reservas,
    );
  }
}
