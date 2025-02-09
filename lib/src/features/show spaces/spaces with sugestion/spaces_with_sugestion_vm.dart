import 'package:Festou/src/core/exceptions/repository_exception.dart';
import 'package:Festou/src/core/fp/either.dart';
import 'package:Festou/src/core/providers/application_providers.dart';
import 'package:Festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_state.dart';
import 'package:Festou/src/models/space_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spaces_with_sugestion_vm.g.dart';

@riverpod
class SpacesWithSugestionVm extends _$SpacesWithSugestionVm {
  String errorMessage = '';

  @override
  Future<SpacesWithSugestionState> build(SpaceModel spaceModel) async {
    final spaceRepository = ref.watch(spaceFirestoreRepositoryProvider);

    try {
      //todo: get spaces with sugestion
      final spacesResult = await spaceRepository.getSugestions(spaceModel);

      switch (spacesResult) {
        case Success(value: final spacesData):
          return SpacesWithSugestionState(
              status: SpacesWithSugestionStateStatus.loaded,
              spaces: spacesData);

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          return SpacesWithSugestionState(
            status: SpacesWithSugestionStateStatus.error,
            spaces: [],
          );
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';

      return SpacesWithSugestionState(
          status: SpacesWithSugestionStateStatus.loaded, spaces: []);
    }
  }
}
