import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quero_ser_locador_vm.g.dart';

enum QueroSerLocadorStateStatus {
  initial,
  success,
  error,
}

@riverpod
class QueroSerLocadorVm extends _$QueroSerLocadorVm {
  @override
  QueroSerLocadorStateStatus build() => QueroSerLocadorStateStatus.initial;

  Future<void> update({
    required User user,
    required String cnpj,
    required String emailComercial,
  }) async {
    final userRepository = ref.watch(userRepositoryProvider);

    final userData = (
      user: user,
      cnpj: cnpj,
      emailComercial: emailComercial,
    );

    final update = await userRepository.updateToLocador(userData);
    switch (update) {
      case Success():
        state = QueroSerLocadorStateStatus.success;
      case Failure():
        state = QueroSerLocadorStateStatus.error;
    }
  }
}
