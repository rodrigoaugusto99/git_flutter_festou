import 'package:Festou/src/models/avaliacoes_model.dart';

enum MinhasAvaliacoesStateStatus { success, error }

class MinhasAvaliacoesState {
  final MinhasAvaliacoesStateStatus status;
  final List<AvaliacoesModel> feedbacks;

  MinhasAvaliacoesState({
    required this.status,
    required this.feedbacks,
  });

  MinhasAvaliacoesState copyWith({
    MinhasAvaliacoesStateStatus? status,
    List<AvaliacoesModel>? feedbacks,
  }) {
    return MinhasAvaliacoesState(
      status: status ?? this.status,
      feedbacks: feedbacks ?? this.feedbacks,
    );
  }
}
