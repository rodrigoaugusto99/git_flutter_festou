import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guest_feedback_page_vm.g.dart';

enum GuestFeedbackRegisterStateStatus {
  initial,
  success,
  error,
}

@riverpod
class GuestFeedbackRegisterVm extends _$GuestFeedbackRegisterVm {
  String errorMessage = '';

  final user = FirebaseAuth.instance.currentUser!;
  @override
  GuestFeedbackRegisterStateStatus build() =>
      GuestFeedbackRegisterStateStatus.initial;

  Future<void> register({
    required String guestId,
    required int rating,
    required String content,
  }) async {
    final feedbackFirestoreRepository =
        ref.watch(feedbackFirestoreRepositoryProvider);

    final userId = user.uid;
    final feedbackData = (
      userId: userId,
      guestId: guestId,
      rating: rating,
      content: content,
    );

    try {
      final registerResult =
          await feedbackFirestoreRepository.saveGuestFeedback(feedbackData);
      switch (registerResult) {
        case Success():
          state = GuestFeedbackRegisterStateStatus.success;
        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          state = GuestFeedbackRegisterStateStatus.error;
      }
    } on Exception {
      errorMessage = 'Erro desconhecido'; // Atualize a mensagem de erro
      state = GuestFeedbackRegisterStateStatus.error;
    }
  }
}
