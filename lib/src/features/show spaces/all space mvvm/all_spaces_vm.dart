import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_spaces_vm.g.dart';

@riverpod
class AllSpacesVm extends _$AllSpacesVm {
  String errorMessage = '';
  @override
  Future<AllSpaceState> build() async {
    final spaceRepository = ref.read(spaceFirestoreRepositoryProvider);

    try {
      final spacesResult = await spaceRepository.getAllSpaces();

      switch (spacesResult) {
        case Success(value: final spacesData):
          return AllSpaceState(
              status: AllSpaceStateStatus.loaded, spaces: spacesData);

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          return AllSpaceState(
            status: AllSpaceStateStatus.error,
            spaces: [],
          );
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';

      return AllSpaceState(status: AllSpaceStateStatus.loaded, spaces: []);
    }
  }
}
