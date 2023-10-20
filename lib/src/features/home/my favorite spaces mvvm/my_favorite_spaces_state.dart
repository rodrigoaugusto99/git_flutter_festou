// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:git_flutter_festou/src/models/space_model.dart';

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
