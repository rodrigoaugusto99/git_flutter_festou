import 'package:festou/src/core/exceptions/repository_exception.dart';
import 'package:festou/src/core/fp/either.dart';
import 'package:festou/src/core/fp/nil.dart';
import 'package:festou/src/models/avaliacoes_model.dart';

abstract interface class FeedbackFirestoreRepository {
  Future<Either<RepositoryException, Nil>> saveFeedback(
    ({
      String spaceId,
      String userId,
      String reservationId,
      int rating,
      String content,
    }) feedbackData,
  );

  Future<Either<RepositoryException, Nil>> saveHostFeedback(
    ({
      String hostId,
      String userId,
      String reservationId,
      int rating,
      String content,
    }) feedbackData,
  );

  Future<Either<RepositoryException, Nil>> saveGuestFeedback(
    ({
      String guestId,
      String userId,
      String reservationId,
      int rating,
      String content,
    }) feedbackData,
  );

  Future<Either<RepositoryException, Nil>> updateFeedback({
    required String feedbackId,
    required String spaceId,
    required String reservationId,
    required String userId,
    required int rating,
    required String content,
  });

  Future<Either<RepositoryException, List<AvaliacoesModel>>> getFeedbacks(
      String spaceId);

  Future<Either<RepositoryException, List<AvaliacoesModel>>> getMyFeedbacks(
      String userId);

  Future<Either<RepositoryException, List<AvaliacoesModel>>>
      getFeedbacksOrdered(String spaceId, String orderBy);
}
