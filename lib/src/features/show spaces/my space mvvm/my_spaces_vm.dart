import 'package:festou/src/core/exceptions/repository_exception.dart';
import 'package:festou/src/core/fp/either.dart';
import 'package:festou/src/core/providers/application_providers.dart';
import 'package:festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_spaces_vm.g.dart';

@riverpod
class MySpacesVm extends _$MySpacesVm {
  String errorMessage = '';
  @override
  Future<MySpacesState> build() async {
    final spaceRepository = ref.read(spaceFirestoreRepositoryProvider);
    try {
      final spacesResult = await spaceRepository.getMySpaces();

      switch (spacesResult) {
        case Success(value: final spacesData):
          return MySpacesState(
              status: MySpacesStateStatus.loaded, spaces: spacesData);

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          return MySpacesState(status: MySpacesStateStatus.error, spaces: []);
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';

      return MySpacesState(status: MySpacesStateStatus.loaded, spaces: []);
    }
  }

  /// 🔹 Método para recarregar a lista de espaços
  Future<void> fetchMySpaces() async {
    final spaceRepository = ref.read(spaceFirestoreRepositoryProvider);
    try {
      final spacesResult = await spaceRepository.getMySpaces();

      switch (spacesResult) {
        case Success(value: final spacesData):
          state = AsyncData(MySpacesState(
              status: MySpacesStateStatus.loaded, spaces: spacesData));
          break;

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          state = AsyncData(
              MySpacesState(status: MySpacesStateStatus.error, spaces: []));
          break;
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';
      state = AsyncData(
          MySpacesState(status: MySpacesStateStatus.loaded, spaces: []));
    }
  }
}
