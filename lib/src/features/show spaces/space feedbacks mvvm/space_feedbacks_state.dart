import 'package:git_flutter_festou/src/models/avaliacoes_model.dart';

enum SpaceFeedbacksStateStatus { success, error }

class SpaceFeedbacksState {
  final SpaceFeedbacksStateStatus status;
  final List<AvaliacoesModel> feedbacks;

  SpaceFeedbacksState({
    required this.status,
    required this.feedbacks,
  });

  SpaceFeedbacksState copyWith({
    SpaceFeedbacksStateStatus? status,
    List<AvaliacoesModel>? feedbacks,
  }) {
    return SpaceFeedbacksState(
      status: status ?? this.status,
      feedbacks: feedbacks ?? this.feedbacks,
    );
  }
}
