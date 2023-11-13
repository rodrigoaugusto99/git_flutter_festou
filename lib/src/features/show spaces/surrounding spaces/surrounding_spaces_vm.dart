import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'surrounding_spaces_vm.g.dart';

@riverpod
class SurroundingSpacesVm extends _$SurroundingSpacesVm {
  String errorMessage = '';
  @override
  Future<SurroundingSpacesState> build() async {
    final spaceRepository = ref.read(spaceFirestoreRepositoryProvider);

    try {
      //todo: get surrounding spaces
      final spacesResult = await spaceRepository.getSurroundingSpaces();

      switch (spacesResult) {
        case Success(value: final spacesData):
          return SurroundingSpacesState(
              status: SurroundingSpacesStateStatus.loaded, spaces: spacesData);

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          return SurroundingSpacesState(
            status: SurroundingSpacesStateStatus.error,
            spaces: [],
          );
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';

      return SurroundingSpacesState(
          status: SurroundingSpacesStateStatus.loaded, spaces: []);
    }
  }
}
