import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'informacoes_pessoais_vm.g.dart';

@riverpod
class InformacoesPessoaisVM extends _$InformacoesPessoaisVM {
  String errorMessage = '';
  @override
  Future<InformacoesPessoaisState> build(String text, String newText) async {
    final usersRepository = ref.watch(userFirestoreRepositoryProvider);

    try {
      final result = await usersRepository.updatetUser(text, newText);

      switch (result) {
        case Success():
          return InformacoesPessoaisState(
            status: InformacoesPessoaisStateStatus.loaded,
            nome: '',
            telefone: '',
            email: '',
          );

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          return InformacoesPessoaisState(
            status: InformacoesPessoaisStateStatus.error,
            nome: '',
            telefone: '',
            email: '',
          );
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';

      return InformacoesPessoaisState(
        status: InformacoesPessoaisStateStatus.error,
        nome: '',
        telefone: '',
        email: '',
      );
    }
  }
}
