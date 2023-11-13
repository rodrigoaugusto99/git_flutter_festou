import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_state.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spaces_with_sugestion_vm.g.dart';

@riverpod
class SpacesWithSugestionVm extends _$SpacesWithSugestionVm {
  String errorMessage = '';

  @override
  Future<SpacesWithSugestionState> build(
      SpaceWithImages spaceWithImages) async {
    final spaceRepository = ref.watch(spaceFirestoreRepositoryProvider);

    try {
      //todo: get spaces with sugestion
      final spacesResult = await spaceRepository.getSugestions(spaceWithImages);

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
