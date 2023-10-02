import 'package:asyncstate/asyncstate.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_register_vm.g.dart';

enum UserRegisterStateStatus {
  initial,
  success,
  error,
}

@riverpod
class UserRegisterVm extends _$UserRegisterVm {
  @override
  UserRegisterStateStatus build() => UserRegisterStateStatus.initial;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    final userRegisterService = ref.watch(userRegisterServiceProvider);

    final userData = (
      email: email,
      password: password,
    );

    final registerResult =
        await userRegisterService.execute(userData).asyncLoader();
    switch (registerResult) {
      case Success():
        state = UserRegisterStateStatus.success;
      case Failure():
        state = UserRegisterStateStatus.error;
    }
  }
}
