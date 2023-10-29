import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

enum MySpacesStateStatus { loaded, error }

class MySpacesState {
  final MySpacesStateStatus status;
  final List<SpaceWithImages> spaces;

  MySpacesState({
    required this.status,
    required this.spaces,
  });

  MySpacesState copyWith({
    MySpacesStateStatus? status,
    List<SpaceWithImages>? spaces,
  }) {
    return MySpacesState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
