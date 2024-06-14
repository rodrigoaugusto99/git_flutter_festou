import 'dart:io';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validatorless/validatorless.dart';
import 'package:git_flutter_festou/src/services/post_service.dart';

class RegisterPostVm {
  RegisterPostVm({
    required this.spaceModel,
  });
  SpaceModel spaceModel;
  TextEditingController tituloEC = TextEditingController();
  TextEditingController descricaoEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final postService = PostService();

  List<File>? imagesToRegister;

  FormFieldValidator<String> validate() {
    return Validatorless.required('Campo obrigatorio');
  }

  void pickImages() async {
    List<File> imageFiles = [];
    final imagePicker = ImagePicker();
    final List<XFile> images = await imagePicker.pickMultiImage();
    for (XFile image in images) {
      final imageFile = File(image.path);
      imageFiles.add(imageFile);
    }
    if (imageFiles != []) {
      imagesToRegister = imageFiles;
    }
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      if (imagesToRegister == null) {
        //todo:messagem pro usuario
        return;
      }
      register();
    }
  }

  Future<void> register() async {
    postService.savePost(
      spaceId: spaceModel.spaceId,
      imageFiles: imagesToRegister!,
      titulo: tituloEC.text,
      descricao: descricaoEC.text,
    );
  }
}
