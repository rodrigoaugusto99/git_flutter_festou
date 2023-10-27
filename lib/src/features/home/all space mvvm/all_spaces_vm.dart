import 'dart:developer';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';
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
          log('$spacesData');

          final spaces = <SpaceWithImages>[];
          spaces.addAll(spacesData);
          return AllSpaceState(
              status: AllSpaceStateStatus.loaded, spaces: spaces);

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          return AllSpaceState(
            status: AllSpaceStateStatus.error,
            spaces: [],
          );
      }
    } on Exception {
      errorMessage = 'Erro desconhecido'; // Atualize a mensagem de erro

      return AllSpaceState(status: AllSpaceStateStatus.loaded, spaces: []);
    }
  }
}
