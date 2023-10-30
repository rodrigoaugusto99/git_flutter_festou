import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

enum SpacesByTypeStateStatus { loaded, error }

class SpacesByTypeState {
  final SpacesByTypeStateStatus status;
  final List<SpaceWithImages> spaces;

  SpacesByTypeState({
    required this.status,
    required this.spaces,
  });

  SpacesByTypeState copyWith({
    SpacesByTypeStateStatus? status,
    List<SpaceWithImages>? spaces,
  }) {
    return SpacesByTypeState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
