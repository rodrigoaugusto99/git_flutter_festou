import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

enum AllSpaceStateStatus { loaded, error }

class AllSpaceState {
  final AllSpaceStateStatus status;
  final List<SpaceWithImages> spaces;

  AllSpaceState({
    required this.status,
    required this.spaces,
  });

  AllSpaceState copyWith({
    AllSpaceStateStatus? status,
    List<SpaceWithImages>? spaces,
  }) {
    return AllSpaceState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
