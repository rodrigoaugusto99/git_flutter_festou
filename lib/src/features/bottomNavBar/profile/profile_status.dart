import 'package:git_flutter_festou/src/models/user_model.dart';

enum ProfileStateStatus { loaded, error }

class ProfileState {
  final ProfileStateStatus status;
  final UserModel? userModel;

  ProfileState({
    required this.status,
    this.userModel,
  });

  ProfileState copyWith({
    ProfileStateStatus? status,
    UserModel? userModel,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userModel: userModel ?? userModel,
    );
  }
}
