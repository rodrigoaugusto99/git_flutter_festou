import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/my%20space%20mvvm/my_spaces_state.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_spaces_vm.g.dart';

@riverpod
class MySpacesVm extends _$MySpacesVm {
  @override
  Future<MySpacesState> build() async {
    final spaceRepository = ref.read(spaceFirestoreRepositoryProvider);
    //final BarbershopModel(id: barbershopId) =
    //await ref.read(getMyBarbershopProvider.future);
    final spacesResult = await spaceRepository.getMySpaces();

    switch (spacesResult) {
      case Success(value: final spacesData):
        final spaces = <SpaceWithImages>[];
        spaces.addAll(spacesData);
        return MySpacesState(
            status: MySpacesStateStatus.loaded, spaces: spaces);

      case Failure():
        return MySpacesState(status: MySpacesStateStatus.error, spaces: []);
    }
  }
}
