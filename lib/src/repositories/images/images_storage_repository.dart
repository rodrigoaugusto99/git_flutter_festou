import 'dart:io';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';

abstract interface class ImagesStorageRepository {
  Future<Either<RepositoryException, Nil>> uploadSpaceImages(
      {required List<File> imageFiles, required String spaceId});
}
