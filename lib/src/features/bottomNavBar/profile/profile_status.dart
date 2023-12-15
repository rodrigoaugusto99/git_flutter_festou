import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/models/user_with_images.dart';

enum ProfileStateStatus { loaded, error }

class ProfileState {
  final ProfileStateStatus status;
  final UserWithImages? userWithImages;

  ProfileState({
    required this.status,
    this.userWithImages,
  });

  ProfileState copyWith({
    ProfileStateStatus? status,
    UserWithImages? userModel,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userWithImages: userModel ?? userWithImages,
    );
  }
}
