import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

enum MyFavoriteSpacesStateStatus { loaded, error }

class MyFavoriteSpacesState {
  final MyFavoriteSpacesStateStatus status;
  final List<SpaceWithImages> spaces;

  MyFavoriteSpacesState({
    required this.status,
    required this.spaces,
  });

  MyFavoriteSpacesState copyWith({
    MyFavoriteSpacesStateStatus? status,
    List<SpaceWithImages>? spaces,
  }) {
    return MyFavoriteSpacesState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
