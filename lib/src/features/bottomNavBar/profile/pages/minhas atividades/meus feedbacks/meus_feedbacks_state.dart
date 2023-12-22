import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/feedback_model.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';

enum MeusFeedbacksStateStatus { success, error }

class MeusFeedbacksState {
  final MeusFeedbacksStateStatus status;
  final List<FeedbackModel> feedbacks;

  MeusFeedbacksState({
    required this.status,
    required this.feedbacks,
  });

  MeusFeedbacksState copyWith({
    MeusFeedbacksStateStatus? status,
    List<FeedbackModel>? feedbacks,
  }) {
    return MeusFeedbacksState(
      status: status ?? this.status,
      feedbacks: feedbacks ?? this.feedbacks,
    );
  }
}
