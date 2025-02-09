import 'package:Festou/src/models/space_model.dart';

enum AllSpaceStateStatus { loaded, error }

class AllSpaceState {
  final AllSpaceStateStatus status;
  final List<SpaceModel> spaces;

  AllSpaceState({
    required this.status,
    required this.spaces,
  });

  AllSpaceState copyWith({
    AllSpaceStateStatus? status,
    List<SpaceModel>? spaces,
  }) {
    return AllSpaceState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
    );
  }
}
