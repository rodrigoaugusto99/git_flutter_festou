import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'space_feedbacks_vm.g.dart';

@riverpod
class SpaceFeedbacksVm extends _$SpaceFeedbacksVm {
  @override
  Future<SpaceFeedbacksState> build(SpaceModel space) async {
    final feedbackRepository = ref.read(feedbackFirestoreRepositoryProvider);

    final feedbackResult = await feedbackRepository.getFeedbacks(space.spaceId);

    switch (feedbackResult) {
      case Success(value: final feedbackData):
        return SpaceFeedbacksState(
            status: SpaceFeedbacksStateStatus.loaded, feedbacks: feedbackData);

      case Failure():
        return SpaceFeedbacksState(
            status: SpaceFeedbacksStateStatus.error, feedbacks: []);
    }
  }
}