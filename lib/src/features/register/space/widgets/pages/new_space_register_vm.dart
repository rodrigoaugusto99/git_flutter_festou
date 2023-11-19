import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/pages/new_space_register_state.dart';
import 'package:git_flutter_festou/src/models/address_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:validatorless/validatorless.dart';

part 'new_space_register_vm.g.dart';

@riverpod
class NewSpaceRegisterVm extends _$NewSpaceRegisterVm {
  @override
  NewSpaceRegisterState build() => NewSpaceRegisterState.initial();

  final uuid = const Uuid();
  final user = FirebaseAuth.instance.currentUser!;

  void addOrRemoveType(String type) {
    final selectedTypesState = state.selectedTypesState.selectedTypes;

    if (selectedTypesState.contains(type)) {
      selectedTypesState.remove(type);
    } else {
      selectedTypesState.add(type);
    }

    state = state.copyWith(
      selectedTypesState: NewSpaceRegisterStateWithSelectedTypes(
        selectedTypes: selectedTypesState,
        status: NewSpaceRegisterStateStatus.success,
      ),
    );
    log('state atualizado');
  }

  void addOrRemoveService(String service) {
    final selectedServicesState = state.selectedServicesState.selectedServices;

    if (selectedServicesState.contains(service)) {
      selectedServicesState.remove(service);
    } else {
      selectedServicesState.add(service);
    }

    state = state.copyWith(
      selectedServicesState: NewSpaceRegisterStateWithSelectedServices(
        selectedServices: selectedServicesState,
        status: NewSpaceRegisterStateStatus.success,
      ),
    );
    log('state atualizado');
  }

  void addAddress(AddressModel address) {
    state = state.copyWith(
      addressModelState: NewSpaceRegisterStateWithAddressModel(
        addressModel: address,
        status: NewSpaceRegisterStateStatus.success,
      ),
    );
    log('state atualizado');
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
      imageFilesState: NewSpaceRegisterStateWithImageFiles(
        imageFiles: imageFiles,
        status: NewSpaceRegisterStateStatus.success,
      ),
    );
    log('state atualizado');
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

  /*Future<void> validateAddressForm(
    BuildContext context,
    formKey,
    cepEC,
    logradouroEC,
    numeroEC,
    bairroEC,
    cidadeEC,
  ) async {
    //if (formKey.currentState?.validate() == true) {
    await register(
      
    );
    //se nao tiver esse else, o compilador passa nesse copyWith sempre
    //} else {
    //state = state.copyWith(status: SpaceRegisterStateStatus.invalidForm);
    //}
  }*/

  Future<void> register() async {
    final NewSpaceRegisterState(
      :selectedTypesState,
      :selectedServicesState,
      :imageFilesState,
      :addressModelState
    ) = state;

    final spaceId = uuid.v4();
    final userId = user.uid;

    String descricao = '';
    String city = '';
    String titulo = '';

    final spaceData = (
      spaceId: spaceId,
      userId: userId,
      titulo: titulo,
      cep: addressModelState.addressModel.cep,
      logradouro: addressModelState.addressModel.logradouro,
      numero: addressModelState.addressModel.numero,
      bairro: addressModelState.addressModel.bairro,
      cidade: addressModelState.addressModel.cidade,
      selectedTypes: selectedTypesState.selectedTypes,
      selectedServices: selectedServicesState.selectedServices,
      imageFiles: imageFilesState.imageFiles,
      descricao: descricao,
      city: city,
    );
    log('spacedata: $spaceData');
    final spaceFirestoreRepository =
        ref.watch(spaceFirestoreRepositoryProvider);

    final registerResultSpace =
        await spaceFirestoreRepository.saveSpace(spaceData);

    switch (registerResultSpace) {
      case Success():
        state = state.copyWith(status: NewSpaceRegisterStateStatus.success);

        log('state: $state');
        break;
      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: NewSpaceRegisterStateStatus.error,
          errorMessage: () => message,
        );
    }
  }
}
