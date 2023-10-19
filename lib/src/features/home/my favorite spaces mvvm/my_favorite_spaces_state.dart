// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:git_flutter_festou/src/models/space_model.dart';

enum MyFavoriteSpacesStatus { loaded, error }

class MyFavoriteSpacesState {
  final MyFavoriteSpacesStatus status;
  final List<SpaceModel> spaces;

  MyFavoriteSpacesState({
    required this.status,
    required this.spaces,
  });

  MyFavoriteSpacesState copyWith({
    MyFavoriteSpacesStatus? status,
    List<SpaceModel>? spaces,
  }) {
    return MyFavoriteSpacesState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
