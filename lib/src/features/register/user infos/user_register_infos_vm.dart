import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> register({
    required User user,
    required String name,
    required String telefone,
    required String cep,
    required String logradouro,
    required String bairro,
    required String cidade,
  }) async {
    final userRepository = ref.watch(userRepositoryProvider);

    final userData = (
      user: user,
      name: name,
      telefone: telefone,
      cep: cep,
      logradouro: logradouro,
      bairro: bairro,
      cidade: cidade,
    );

    final registerResult = await userRepository.registerUserInfos(userData);
    switch (registerResult) {
      case Success():
        state = UserRegisterInfosStateStatus.success;
      case Failure():
        state = UserRegisterInfosStateStatus.error;
    }
  }
}
