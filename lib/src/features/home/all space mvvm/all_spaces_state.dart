// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:git_flutter_festou/src/models/space_model.dart';
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
