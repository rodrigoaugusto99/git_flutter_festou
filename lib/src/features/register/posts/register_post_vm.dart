import 'dart:io';
import 'package:flutter/material.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validatorless/validatorless.dart';
import 'package:festou/src/services/post_service.dart';

class RegisterPostVm with ChangeNotifier {
  RegisterPostVm({
    required this.spaceModel,
  });
  SpaceModel spaceModel;
  TextEditingController tituloEC = TextEditingController();
  TextEditingController descricaoEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final postService = PostService();

  List<File> imagesToRegister = [];

  FormFieldValidator<String> validate() {
    return Validatorless.required('Campo obrigatório');
  }

  File? photoShowing;

  void onPhotoTap(int index) {
    photoShowing = imagesToRegister[index];
    notifyListeners();
  }

  void deletarTudo() {
    imagesToRegister = [];
    notifyListeners();
  }

  void deletarImagem(int index) {
    if (imagesToRegister.length == 1) {
      photoShowing = null;
      imagesToRegister.removeAt(index);
    } else if (imagesToRegister[index] == photoShowing) {
      imagesToRegister.removeAt(index);
      photoShowing = imagesToRegister[0];
    } else {
      imagesToRegister.removeAt(index);
    }

    notifyListeners();
  }

  void pickImages() async {
    final imagePicker = ImagePicker();
    final List<XFile> images = await imagePicker.pickMultiImage();
    for (XFile image in images) {
      final imageFile = File(image.path);
      imagesToRegister.add(imageFile);
    }

    photoShowing = imagesToRegister[0];

    notifyListeners();
    // if (imageFiles != []) {
    //   imagesToRegister!.add(imageFiles);
    // }
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      register();
    }
  }

  Future<void> register() async {
    await postService.savePost(
      spaceId: spaceModel.spaceId,
      imageFiles: imagesToRegister,
      titulo: tituloEC.text,
      descricao: descricaoEC.text,
      coverPhoto: photoShowing!,
    );
  }
}
