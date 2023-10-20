import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/my%20favorite%20spaces%20mvvm/my_favorite_spaces_state.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_favorite_spaces_vm.g.dart';

@riverpod
class MyFavoriteSpacesVm extends _$MyFavoriteSpacesVm {
  @override
  Future<MyFavoriteSpacesState> build() async {
    final spaceRepository = ref.watch(spaceFirestoreRepositoryProvider);

    final spacesResult = await spaceRepository.getMyFavoriteSpaces();

    switch (spacesResult) {
      case Success(value: final spacesData):
        return MyFavoriteSpacesState(
            status: MyFavoriteSpacesStateStatus.loaded, spaces: spacesData);

      case Failure():
        return MyFavoriteSpacesState(
            status: MyFavoriteSpacesStateStatus.error, spaces: []);
    }
  }
}
