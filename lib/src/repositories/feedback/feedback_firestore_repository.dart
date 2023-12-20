import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/feedback_model.dart';

abstract interface class FeedbackFirestoreRepository {
  Future<Either<RepositoryException, Nil>> saveFeedback(
    ({
      String spaceId,
      String userId,
      int rating,
      String content,
    }) feedbackData,
  );
  Future<Either<RepositoryException, Nil>> saveHostFeedback(
    ({
      String hostId,
      String userId,
      int rating,
      String content,
    }) feedbackData,
  );
  Future<Either<RepositoryException, List<FeedbackModel>>> getFeedbacks(
      String spaceId);

  Future<Either<RepositoryException, List<FeedbackModel>>> getFeedbacksOrdered(
      String spaceId, String orderBy);
}
