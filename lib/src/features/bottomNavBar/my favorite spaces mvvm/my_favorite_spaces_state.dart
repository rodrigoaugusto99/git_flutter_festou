import 'package:festou/src/models/space_model.dart';

enum MyFavoriteSpacesStateStatus { loaded, error }

class MyFavoriteSpacesState {
  final MyFavoriteSpacesStateStatus status;
  final List<SpaceModel> spaces;

  MyFavoriteSpacesState({
    required this.status,
    required this.spaces,
  });

  MyFavoriteSpacesState copyWith({
    MyFavoriteSpacesStateStatus? status,
    List<SpaceModel>? spaces,
  }) {
    return MyFavoriteSpacesState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
