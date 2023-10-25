import 'dart:developer';

import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/all%20space%20mvvm/all_spaces_state.dart';

import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_spaces_vm.g.dart';

@riverpod
class AllSpacesVm extends _$AllSpacesVm {
  @override
  Future<AllSpaceState> build() async {
    final spaceRepository = ref.read(spaceFirestoreRepositoryProvider);
    //final BarbershopModel(id: barbershopId) =
    //await ref.read(getMyBarbershopProvider.future);
    final spacesResult = await spaceRepository.getAllSpaces();

    switch (spacesResult) {
      case Success(value: final spacesData):
        log('$spacesData');

        final spaces = <SpaceModel>[];
        spaces.addAll(spacesData);
        return AllSpaceState(
            status: AllSpaceStateStatus.loaded, spaces: spaces);

      case Failure():
        return AllSpaceState(status: AllSpaceStateStatus.error, spaces: []);
    }
  }
}
