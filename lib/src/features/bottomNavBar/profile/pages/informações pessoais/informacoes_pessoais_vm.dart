import 'dart:io';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais_status.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'informacoes_pessoais_vm.g.dart';

@riverpod
class InformacoesPessoaisVM extends _$InformacoesPessoaisVM {
  @override
  InformacoesPessoaisState build() => InformacoesPessoaisState.initial();

  Future<void> updateInfo({
    required String cidade,
    required String name,
    required String cep,
    required String email,
    required String telefone,
    required String logradouro,
    required String bairro,
  }) async {
    final usersRepository = ref.watch(userFirestoreRepositoryProvider);

    final a = await usersRepository.updatetUser('cidade', cidade);
    final b = await usersRepository.updatetUser('name', name);
    final c = await usersRepository.updatetUser('cep', cep);
    final d = await usersRepository.updatetUser('email', email);
    final e = await usersRepository.updatetUser('telefone', telefone);
    final f = await usersRepository.updatetUser('logradouro', logradouro);
    final g = await usersRepository.updatetUser('bairro', bairro);
    switch (a) {
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

  Future pickAvatar() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    File? img = File(image.path);
    img = await _cropAvatar(imageFile: img);
    state = state.copyWith(
        status: InformacoesPessoaisStateStatus.success, avatarCropped: img);
  }

  Future<File?> _cropAvatar({required File imageFile}) async {
    CroppedFile? croppedFile =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedFile == null) return null;

    return File(croppedFile.path);
  }

  Future<bool> uploadAvatar(String userId) async {
    final InformacoesPessoaisState(:avatarCropped) = state;

    final imageStorageRepository = ref.watch(imagesStorageRepositoryProvider);

    final result2 = await imageStorageRepository.uploadAvatarImage(
        avatar: avatarCropped, userId: userId);

    switch (result2) {
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

  Future<bool> deleteImageFirestore(String fieldName, String userId) async {
    final imageStorageRepository = ref.watch(userFirestoreRepositoryProvider);

    final result = await imageStorageRepository.clearField(fieldName, userId);

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
}
