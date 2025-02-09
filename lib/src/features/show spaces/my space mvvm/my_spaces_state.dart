import 'package:Festou/src/models/space_model.dart';

enum MySpacesStateStatus { loaded, error }

class MySpacesState {
  final MySpacesStateStatus status;
  final List<SpaceModel> spaces;

  MySpacesState({
    required this.status,
    required this.spaces,
  });

  MySpacesState copyWith({
    MySpacesStateStatus? status,
    List<SpaceModel>? spaces,
  }) {
    return MySpacesState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
