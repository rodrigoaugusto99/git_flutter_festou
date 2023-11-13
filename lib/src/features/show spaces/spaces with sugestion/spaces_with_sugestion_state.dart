import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

enum SpacesWithSugestionStateStatus { loaded, error }

class SpacesWithSugestionState {
  final SpacesWithSugestionStateStatus status;
  final List<SpaceWithImages> spaces;

  SpacesWithSugestionState({
    required this.status,
    required this.spaces,
  });

  SpacesWithSugestionState copyWith({
    SpacesWithSugestionStateStatus? status,
    List<SpaceWithImages>? spaces,
  }) {
    return SpacesWithSugestionState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
