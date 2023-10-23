import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';

abstract interface class FeedbackFirestoreRepository {
  Future<Either<RepositoryException, Nil>> saveFeedback(
    ({
      String spaceId,
      String userId,
      String rating,
      String content,
    }) feedbackData,
  );
  Future<Either<RepositoryException, Nil>> getSpaceFeedback();
}
