import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20by%20type/spaces_by_type_state.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20with%20sugestion/spaces_with_sugestion_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'spaces_by_type_vm.g.dart';

@riverpod
class SpacesWithSugestionVm extends _$SpacesWithSugestionVm {
  String errorMessage = '';
  @override
  Future<SpacesWithSugestionState> build() async {
    final spaceRepository = ref.read(spaceFirestoreRepositoryProvider);

    try {
      //todo: get spaces with sugestion
      final spacesResult = await spaceRepository.getAllSpaces();

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
