import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_register_infos_vm.g.dart';

enum UserRegisterInfosStateStatus {
  initial,
  success,
  error,
}

@riverpod
class UserRegisterInfosVm extends _$UserRegisterInfosVm {
  @override
  UserRegisterInfosStateStatus build() => UserRegisterInfosStateStatus.initial;

  Future<void> register() async {
    final userRepository = ref.watch(userRepositoryProvider);

    const userData = ();

    final registerResult = await userRepository.registerUserInfos(userData);
    switch (registerResult) {
      case Success():
        state = UserRegisterInfosStateStatus.success;
      case Failure():
        state = UserRegisterInfosStateStatus.error;
    }
  }
}
