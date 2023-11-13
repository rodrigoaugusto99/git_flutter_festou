import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

enum SurroundingSpacesStateStatus { loaded, error }

class SurroundingSpacesState {
  final SurroundingSpacesStateStatus status;
  final List<SpaceWithImages> spaces;

  SurroundingSpacesState({
    required this.status,
    required this.spaces,
  });

  SurroundingSpacesState copyWith({
    SurroundingSpacesStateStatus? status,
    List<SpaceWithImages>? spaces,
  }) {
    return SurroundingSpacesState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
