import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';

import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20by%20type/spaces_by_type_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spaces_by_type_vm.g.dart';

@riverpod
class SpacesByTypeVm extends _$SpacesByTypeVm {
  String errorMessage = '';
  @override
  Future<SpacesByTypeState> build(List<String> type) async {
    final spaceRepository = ref.read(spaceFirestoreRepositoryProvider);

    try {
      //todo: get by type
      final spacesResult = await spaceRepository.getSpacesByType(type);

      switch (spacesResult) {
        case Success(value: final spacesData):
          return SpacesByTypeState(
              status: SpacesByTypeStateStatus.loaded, spaces: spacesData);

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          return SpacesByTypeState(
            status: SpacesByTypeStateStatus.error,
            spaces: [],
          );
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';

      return SpacesByTypeState(
          status: SpacesByTypeStateStatus.loaded, spaces: []);
    }
  }
}
