// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:git_flutter_festou/src/models/space_model.dart';
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
