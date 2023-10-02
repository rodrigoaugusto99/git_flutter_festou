import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/home_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_vm.g.dart';

@riverpod
class HomeVm extends _$HomeVm {
  @override
  Future<HomeState> build() async {
    /*implementacao no build. quando carregar o HomeVm
  ele vai buscar os dados que 'a tela precisa(nome do usuario p dar boas vindas,
  espacos disponivis p ele alugar, etc.*/
    return HomeState(status: HomeStateStatus.loaded);
  }

  Future<void> logout() => ref.read(logoutProvider.future);
}
