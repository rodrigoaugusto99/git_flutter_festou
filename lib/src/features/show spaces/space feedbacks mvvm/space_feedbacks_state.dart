import 'package:git_flutter_festou/src/models/feedback_model.dart';

enum SpaceFeedbacksStateStatus { success, error }

class SpaceFeedbacksState {
  final SpaceFeedbacksStateStatus status;
  final List<FeedbackModel> feedbacks;

  SpaceFeedbacksState({
    required this.status,
    required this.feedbacks,
  });

  SpaceFeedbacksState copyWith({
    SpaceFeedbacksStateStatus? status,
    List<FeedbackModel>? feedbacks,
  }) {
    return SpaceFeedbacksState(
      status: status ?? this.status,
      feedbacks: feedbacks ?? this.feedbacks,
    );
  }
}
