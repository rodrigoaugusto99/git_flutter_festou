import 'dart:developer';
import 'dart:io';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card_state.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'space_card_vm.g.dart';

@riverpod
class SpaceCardVm extends _$SpaceCardVm {
  @override
  Future<SpaceCardState> build(SpaceModel space) async {
    final imagesStorageRepository = ref.read(imagesStorageRepositoryProvider);
    final imageUrlsResult =
        await imagesStorageRepository.getSpaceImages(space.spaceId);

    switch (imageUrlsResult) {
      case Success(value: final imagesData):
        log('$imagesData');

        return SpaceCardState(
            status: SpaceCardVmStateStatus.loaded, imageUrls: imagesData);

      default:
        return SpaceCardState(
            status: SpaceCardVmStateStatus.error, imageUrls: []);
    }
  }
}
