import 'package:git_flutter_festou/src/models/user_model.dart';

enum ShowMyReservationsInfosStateStatus { loaded, error }

class ShowMyReservationsInfosState {
  final ShowMyReservationsInfosStateStatus status;
  final UserModel? user;

  ShowMyReservationsInfosState({
    required this.status,
    this.user,
  });

  ShowMyReservationsInfosState copyWith({
    ShowMyReservationsInfosStateStatus? status,
    UserModel? user,
  }) {
    return ShowMyReservationsInfosState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
