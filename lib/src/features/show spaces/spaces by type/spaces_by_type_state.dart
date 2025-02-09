import 'package:Festou/src/models/space_model.dart';

enum SpacesByTypeStateStatus { loaded, error }

class SpacesByTypeState {
  final SpacesByTypeStateStatus status;
  final List<SpaceModel> spaces;

  SpacesByTypeState({
    required this.status,
    required this.spaces,
  });

  SpacesByTypeState copyWith({
    SpacesByTypeStateStatus? status,
    List<SpaceModel>? spaces,
  }) {
    return SpacesByTypeState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
