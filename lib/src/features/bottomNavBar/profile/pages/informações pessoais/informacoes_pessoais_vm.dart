import 'dart:io';

import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_status.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'informacoes_pessoais_vm.g.dart';

@riverpod
class InformacoesPessoaisVM extends _$InformacoesPessoaisVM {
  @override
  InformacoesPessoaisState build() => InformacoesPessoaisState.initial();

  Future<void> updateInfo(String text, String newText) async {
    final usersRepository = ref.watch(userFirestoreRepositoryProvider);

    final result = await usersRepository.updatetUser(text, newText);
    switch (result) {
      case Success():
        state = state.copyWith(
          status: InformacoesPessoaisStateStatus.success,
        );

      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: InformacoesPessoaisStateStatus.error,
          errorMessage: () => message,
        );
    }
  }

  void pickAvatar() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File avatarFile = File(image.path);
      state = state.copyWith(
        avatar: avatarFile,
        status: InformacoesPessoaisStateStatus.success,
      );
    } else {
      // O usuário cancelou a seleção de imagem.
      // Adicione tratamento de acordo com suas necessidades.
    }
  }

  void pickImage1() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File imageFile = File(image.path);
      state = state.copyWith(
        image1: imageFile,
        status: InformacoesPessoaisStateStatus.success,
      );
    } else {
      // O usuário cancelou a seleção de imagem.
      // Adicione tratamento de acordo com suas necessidades.
    }
  }

  void pickImage2() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File imageFile = File(image.path);
      state = state.copyWith(
        image2: imageFile,
        status: InformacoesPessoaisStateStatus.success,
      );
    } else {
      // O usuário cancelou a seleção de imagem.
      // Adicione tratamento de acordo com suas necessidades.
    }
  }

  void pickImage() async {
    final List<File> imageFiles = [];
    final imagePicker = ImagePicker();
    final List<XFile> images = await imagePicker.pickMultiImage();
    for (XFile image in images) {
      final imageFile = File(image.path);
      imageFiles.add(imageFile);
    }
    state = state.copyWith(
      imageFiles: imageFiles,
      status: InformacoesPessoaisStateStatus.success,
    );
  }

  void uploadNewImages(String userId) async {
    final InformacoesPessoaisState(:image1, :image2, :avatar) = state;
    //final InformacoesPessoaisState(:imageFiles) = state;

    final imageStorageRepository = ref.watch(imagesStorageRepositoryProvider);
    state = state.copyWith(imageFiles: [image1, image2, avatar]);
    List<File> allImages = state.imageFiles;

    final result2 = await imageStorageRepository.uploadDocImages(
        imageFiles: allImages, userId: userId);

    switch (result2) {
      case Success():
        state = state.copyWith(
          status: InformacoesPessoaisStateStatus.success,
        );

      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: InformacoesPessoaisStateStatus.error,
          errorMessage: () => message,
        );
    }
  }

  Future<bool> deleteImage(String userId, int index) async {
    final imageStorageRepository = ref.watch(imagesStorageRepositoryProvider);

    final result = await imageStorageRepository.deleteDocImage(
        userId: userId, imageIndex: index);

    switch (result) {
      case Success():
        state = state.copyWith(
          status: InformacoesPessoaisStateStatus.success,
        );
        return true;

      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: InformacoesPessoaisStateStatus.error,
          errorMessage: () => message,
        );
        return false;
    }
  }

//ver as fotos que estao armazenadas no estado
//(as que estão no banco)
  /*Future<List<String>> getNewImages(String userId) async {
    final imageStorageRepository = ref.watch(imagesStorageRepositoryProvider);

    final result3 = await imageStorageRepository.getDocImages(userId);

    switch (result3) {
      case Success(value: final imageFiles):
        return imageFiles;

      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: InformacoesPessoaisStateStatus.error,
          errorMessage: () => message,
        );
        return [];
    }
  }*/
}



/*Future<String> getInfo(String string) async {
    final usersRepository = ref.watch(userFirestoreRepositoryProvider);
    final result = await UserFirestoreRepositoryImpl().getInfo(string);

    return result;
  }*/