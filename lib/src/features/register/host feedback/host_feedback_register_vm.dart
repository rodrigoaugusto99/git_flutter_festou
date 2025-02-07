import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'host_feedback_register_vm.g.dart';

enum HostFeedbackRegisterStateStatus {
  initial,
  success,
  error,
}

@riverpod
class HostFeedbackRegisterVm extends _$HostFeedbackRegisterVm {
  String errorMessage = '';

  final user = FirebaseAuth.instance.currentUser!;
  @override
  HostFeedbackRegisterStateStatus build() =>
      HostFeedbackRegisterStateStatus.initial;

  Future<void> register({
    required String hostId,
    required String reservationId,
    required int rating,
    required String content,
  }) async {
    final feedbackFirestoreRepository =
        ref.watch(feedbackFirestoreRepositoryProvider);

    final userId = user.uid;
    final feedbackData = (
      userId: userId,
      reservationId: reservationId,
      hostId: hostId,
      rating: rating,
      content: content,
    );

    try {
      final registerResult =
          await feedbackFirestoreRepository.saveHostFeedback(feedbackData);
      switch (registerResult) {
        case Success():
          state = HostFeedbackRegisterStateStatus.success;
        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          state = HostFeedbackRegisterStateStatus.error;
      }
    } on Exception {
      errorMessage = 'Erro desconhecido'; // Atualize a mensagem de erro
      state = HostFeedbackRegisterStateStatus.error;
    }
  }
}
