import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_register_vm.g.dart';

enum FeedbackRegisterStateStatus {
  initial,
  success,
  error,
}

@riverpod
class FeedbackRegisterVm extends _$FeedbackRegisterVm {
  String errorMessage = '';

  final user = FirebaseAuth.instance.currentUser!;

  @override
  FeedbackRegisterStateStatus build() => FeedbackRegisterStateStatus.initial;

  /// **Registra um novo feedback**
  Future<void> register({
    required String spaceId,
    required int rating,
    required String content,
  }) async {
    final feedbackFirestoreRepository =
        ref.watch(feedbackFirestoreRepositoryProvider);

    final userId = user.uid;
    final feedbackData = (
      userId: userId,
      spaceId: spaceId,
      rating: rating,
      content: content,
    );

    try {
      final registerResult =
          await feedbackFirestoreRepository.saveFeedback(feedbackData);
      switch (registerResult) {
        case Success():
          state = FeedbackRegisterStateStatus.success;
        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          state = FeedbackRegisterStateStatus.error;
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';
      state = FeedbackRegisterStateStatus.error;
    }
  }

  /// **Atualiza um feedback existente**
  Future<void> updateFeedback({
    required String feedbackId,
    required String spaceId,
    required int rating,
    required String content,
  }) async {
    final feedbackFirestoreRepository =
        ref.watch(feedbackFirestoreRepositoryProvider);

    final userId = user.uid;

    try {
      final updateResult = await feedbackFirestoreRepository.updateFeedback(
        feedbackId: feedbackId,
        userId: userId,
        spaceId: spaceId,
        rating: rating,
        content: content,
      );
      switch (updateResult) {
        case Success():
          state = FeedbackRegisterStateStatus.success;
        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          state = FeedbackRegisterStateStatus.error;
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';
      state = FeedbackRegisterStateStatus.error;
    }
  }
}
