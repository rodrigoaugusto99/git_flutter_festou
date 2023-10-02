import 'package:asyncstate/asyncstate.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'login_state.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVM extends _$LoginVM {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String email, String password) async {
    final loaderHandler = AsyncLoaderHandler()..start();
    final userRepository = ref.watch(userRepositoryProvider);

    final loginResult = await userRepository.login(email, password);

    switch (loginResult) {
      case Success():
        state = state.copyWith(status: LoginStateStatus.userLogin);
        break;
      case Failure(exception: AuthError(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
    loaderHandler.close();
  }
}
