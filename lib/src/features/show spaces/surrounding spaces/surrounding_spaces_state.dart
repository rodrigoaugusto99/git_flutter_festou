import 'package:git_flutter_festou/src/models/space_model.dart';

enum SurroundingSpacesStateStatus { loaded, error }

class SurroundingSpacesState {
  final SurroundingSpacesStateStatus status;
  final List<SpaceModel> spaces;

  SurroundingSpacesState({
    required this.status,
    required this.spaces,
  });

  SurroundingSpacesState copyWith({
    SurroundingSpacesStateStatus? status,
    List<SpaceModel>? spaces,
  }) {
    return SurroundingSpacesState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
