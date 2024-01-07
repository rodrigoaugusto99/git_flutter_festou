import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/profile_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_vm.g.dart';

@riverpod
class ProfileVM extends _$ProfileVM {
  String errorMessage = '';
  @override
  Future<ProfileState> build() async {
    final userRepository = ref.read(userFirestoreRepositoryProvider);

    try {
      final usersResult = await userRepository.getUser();

      switch (usersResult) {
        case Success(value: final userModel):
          return ProfileState(
              status: ProfileStateStatus.loaded, userModel: userModel);

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          return ProfileState(
            status: ProfileStateStatus.error,
          );
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';

      return ProfileState(status: ProfileStateStatus.loaded);
    }
  }
}
