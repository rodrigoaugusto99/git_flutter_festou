import 'package:git_flutter_festou/src/models/space_with_image_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/models/user_with_images.dart';

enum ShowMyReservationsInfosStateStatus { loaded, error }

class ShowMyReservationsInfosState {
  final ShowMyReservationsInfosStateStatus status;
  final UserWithImages? user;

  ShowMyReservationsInfosState({
    required this.status,
    this.user,
  });

  ShowMyReservationsInfosState copyWith({
    ShowMyReservationsInfosStateStatus? status,
    UserWithImages? user,
  }) {
    return ShowMyReservationsInfosState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
