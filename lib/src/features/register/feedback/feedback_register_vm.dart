import 'package:firebase_auth/firebase_auth.dart';
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
  final user = FirebaseAuth.instance.currentUser!;
  @override
  FeedbackRegisterStateStatus build() => FeedbackRegisterStateStatus.initial;

  Future<void> register({
    required String spaceId,
    required String rating,
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

    final registerResult =
        await feedbackFirestoreRepository.saveFeedback(feedbackData);
    switch (registerResult) {
      case Success():
        state = FeedbackRegisterStateStatus.success;
      case Failure():
        state = FeedbackRegisterStateStatus.error;
    }
  }
}
