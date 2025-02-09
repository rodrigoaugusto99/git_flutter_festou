import 'package:Festou/src/core/fp/either.dart';
import 'package:Festou/src/core/providers/application_providers.dart';
import 'package:Festou/src/features/bottomNavBar/profile/pages/reservas%20e%20avalia%C3%A7%C3%B5es/meus%20feedbacks/minhas_avaliacoes_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'minhas_avaliacoes_vm.g.dart';

@riverpod
class MinhasAvaliacoesVm extends _$MinhasAvaliacoesVm {
  @override
  Future<MinhasAvaliacoesState> build(String userId) async {
    final feedbacksRepository = ref.read(feedbackFirestoreRepositoryProvider);

    final feedbacksResult = await feedbacksRepository.getMyFeedbacks(userId);

    switch (feedbacksResult) {
      case Success(value: final feedbacksData):
        return MinhasAvaliacoesState(
          status: MinhasAvaliacoesStateStatus.success,
          feedbacks: feedbacksData,
        );

      case Failure():
        return MinhasAvaliacoesState(
          status: MinhasAvaliacoesStateStatus.error,
          feedbacks: [],
        );
    }
  }
}
