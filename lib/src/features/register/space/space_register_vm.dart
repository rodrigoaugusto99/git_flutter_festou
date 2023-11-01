import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:validatorless/validatorless.dart';

part 'space_register_vm.g.dart';

@riverpod
class SpaceRegisterVm extends _$SpaceRegisterVm {
  @override
  SpaceRegisterState build() => SpaceRegisterState.initial();

  final uuid = const Uuid();
  final user = FirebaseAuth.instance.currentUser!;

  void addOrRemoveAvailableDay(String weekDay) {
    final availableDays = state.availableDays;

    if (availableDays.contains(weekDay)) {
      availableDays.remove(weekDay);
    } else {
      availableDays.add(weekDay);
    }

    state = state.copyWith(
        availableDays: availableDays, status: SpaceRegisterStateStatus.initial);
  }

  void addOrRemoveType(String type) {
    final selectedTypes = state.selectedTypes;

    if (selectedTypes.contains(type)) {
      selectedTypes.remove(type);
    } else {
      selectedTypes.add(type);
    }

    state = state.copyWith(
        selectedTypes: selectedTypes, status: SpaceRegisterStateStatus.initial);
  }
  /*outra abordagem para evitar a att do estado
  
  void addOrRemoveType(String type) {
  final selectedTypes = List<String>.from(state.selectedTypes);

  if (selectedTypes.contains(type)) {
    selectedTypes.remove(type);
  } else {
    selectedTypes.add(type);
  }

  if (selectedTypes != state.selectedTypes) {
    state = state.copyWith(selectedTypes: selectedTypes);
  }
}
 criando cópias das listas antes de fazer qualquer alteração e, 
 em seguida, verificando se a lista atualizada é diferente da 
 lista no estado. Somente quando houver uma diferença, 
 atualizamos o estado */

  void addOrRemoveService(String service) {
    final selectedServices = state.selectedServices;

    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }

    state = state.copyWith(
        selectedServices: selectedServices,
        status: SpaceRegisterStateStatus.initial);
  }

  FormFieldValidator<String> validateNome() {
    return Validatorless.required('Nome obrigatorio');
  }

  FormFieldValidator<String> validateEmail() {
    return Validatorless.multiple([
      Validatorless.required('Email obrigatorio'),
      Validatorless.email('Email invalido')
    ]);
  }

  FormFieldValidator<String> validateCEP() {
    return Validatorless.required('CEP obrigatorio');
  }

  FormFieldValidator<String> validateLogradouro() {
    return Validatorless.required('Logradouro obrigatorio');
  }

  FormFieldValidator<String> validateNumero() {
    return Validatorless.required('Número obigatorio');
  }

  FormFieldValidator<String> validateBairro() {
    return Validatorless.required('Bairro obrigatorio');
  }

  FormFieldValidator<String> validateCidade() {
    return Validatorless.required('Cidade obrigatorio');
  }

  Future<void> validateForm(BuildContext context, formKey, nomeEC, emailEC,
      cepEC, logradouroEC, numeroEC, bairroEC, cidadeEC) async {
    //if (formKey.currentState?.validate() == true) {
    await register(
      nomeEC.text,
      emailEC.text,
      cepEC.text,
      logradouroEC.text,
      numeroEC.text,
      bairroEC.text,
      cidadeEC.text,
    );
    //se nao tiver esse else, o compilador passa nesse copyWith sempre
    //} else {
    //state = state.copyWith(status: SpaceRegisterStateStatus.invalidForm);
    //}
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
      status: SpaceRegisterStateStatus.error,
    );
  }

  Future<void> register(
    String name,
    String email,
    String cep,
    String logradouro,
    String numero,
    String bairro,
    String cidade,
  ) async {
    final SpaceRegisterState(
      :selectedTypes,
      :availableDays,
      :selectedServices,
      :imageFiles
    ) = state;

    final spaceId = uuid.v4();
    final userId = user.uid;

    final spaceData = (
      spaceId: spaceId,
      userId: userId,
      name: name,
      email: email,
      cep: cep,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
      selectedTypes: selectedTypes,
      availableDays: availableDays,
      selectedServices: selectedServices,
      imageFiles: imageFiles,
    );

    final spaceFirestoreRepository = ref.read(spaceFirestoreRepositoryProvider);

    final registerResultSpace =
        await spaceFirestoreRepository.saveSpace(spaceData);

    switch (registerResultSpace) {
      case Success():
        state = state.copyWith(status: SpaceRegisterStateStatus.success);
        log('state: $state');
        break;
      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: SpaceRegisterStateStatus.error,
          errorMessage: () => message,
        );
    }
  }
}
