import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/meus_feedbacks_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meus_feedbacks_vm.g.dart';

@riverpod
class MeusFeedbacksVm extends _$MeusFeedbacksVm {
  @override
  Future<MeusFeedbacksState> build(String userId) async {
    final feedbacksRepository = ref.read(feedbackFirestoreRepositoryProvider);

    final feedbacksResult = await feedbacksRepository.getMyFeedbacks(userId);

    switch (feedbacksResult) {
      case Success(value: final feedbacksData):
        return MeusFeedbacksState(
          status: MeusFeedbacksStateStatus.success,
          feedbacks: feedbacksData,
        );

      case Failure():
        return MeusFeedbacksState(
          status: MeusFeedbacksStateStatus.error,
          feedbacks: [],
        );
    }
  }
}
