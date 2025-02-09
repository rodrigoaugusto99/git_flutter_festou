import 'package:Festou/src/core/fp/either.dart';
import 'package:Festou/src/core/providers/application_providers.dart';
import 'package:Festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:Festou/src/models/space_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'space_feedbacks_vm.g.dart';

@riverpod
class SpaceFeedbacksVm extends _$SpaceFeedbacksVm {
  @override
  Future<SpaceFeedbacksState> build(SpaceModel space, String filter) async {
    final feedbackRepository = ref.read(feedbackFirestoreRepositoryProvider);

    final feedbackResult =
        await feedbackRepository.getFeedbacksOrdered(space.spaceId, filter);

    switch (feedbackResult) {
      case Success(value: final feedbackData):
        return SpaceFeedbacksState(
          status: SpaceFeedbacksStateStatus.success,
          feedbacks: feedbackData,
        );

      case Failure():
        return SpaceFeedbacksState(
          status: SpaceFeedbacksStateStatus.error,
          feedbacks: [],
        );
    }
  }
}
