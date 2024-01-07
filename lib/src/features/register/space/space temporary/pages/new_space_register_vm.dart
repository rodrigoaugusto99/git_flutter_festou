import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    final selectedTypes = state.selectedTypes;

    if (selectedTypes.contains(type)) {
      selectedTypes.remove(type);
    } else {
      selectedTypes.add(type);
    }

    state = state.copyWith(
      selectedTypes: selectedTypes,
      status: NewSpaceRegisterStateStatus.success,
    );
    log('----state atualizado----');
    log('${state.selectedTypes}');
    log('${state.selectedServices}');
    log(state.cep);
    log(state.logradouro);
    log(state.numero);
    log(state.bairro);
    log(state.cidade);
  }

  void addOrRemoveService(String service) {
    final selectedServices = state.selectedServices;

    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }

    state = state.copyWith(
      status: NewSpaceRegisterStateStatus.success,
      selectedServices: selectedServices,
    );
    log('----state atualizado----');
    log('${state.selectedTypes}');
    log('${state.selectedServices}');
    log(state.cep);
    log(state.logradouro);
    log(state.numero);
    log(state.bairro);
    log(state.cidade);
  }

  bool validateTitulo(String titulo) {
    if (titulo.isEmpty) {
      return false;
    } else {
      state = state.copyWith(
        status: NewSpaceRegisterStateStatus.success,
        titulo: titulo,
      );
      log('----state atualizado----');
      log('${state.selectedTypes}');
      log('${state.selectedServices}');
      log(state.cep);
      log(state.logradouro);
      log(state.numero);
      log(state.bairro);
      log(state.cidade);
      log(state.titulo);
      return true;
    }
  }

  bool validateDescricao(String descricao) {
    if (descricao.isEmpty) {
      return false;
    } else {
      state = state.copyWith(
        status: NewSpaceRegisterStateStatus.success,
        titulo: descricao,
      );
      log('----state atualizado----');
      log('${state.selectedTypes}');
      log('${state.selectedServices}');
      log(state.cep);
      log(state.logradouro);
      log(state.numero);
      log(state.bairro);
      log(state.cidade);
      log(state.titulo);
      log(state.descricao);
      return true;
    }
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

  Future<void> validateForm(
    BuildContext context,
    formKey,
    cepEC,
    logradouroEC,
    numeroEC,
    bairroEC,
    cidadeEC,
  ) async {
    if (formKey.currentState?.validate() == true) {
      state = state.copyWith(
        status: NewSpaceRegisterStateStatus.success,
        cep: cepEC.text,
        logradouro: logradouroEC.text,
        numero: numeroEC.text,
        bairro: bairroEC.text,
        cidade: cidadeEC.text,
      );
      log('----state atualizado----');
      log('${state.selectedTypes}');
      log('${state.selectedServices}');
      log(state.cep);
      log(state.logradouro);
      log(state.numero);
      log(state.bairro);
      log(state.cidade);
    } else {
      state = state.copyWith(status: NewSpaceRegisterStateStatus.invalidForm);
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
      status: NewSpaceRegisterStateStatus.success,
    );
    log('----state atualizado----');
    log('${state.selectedTypes}');
    log('${state.selectedServices}');
    log(state.cep);
    log(state.logradouro);
    log(state.numero);
    log(state.bairro);
    log(state.cidade);
    log('${state.imageFiles}');
  }

  Future<LatLng> calculateLatLng(
    String logradouro,
    String numero,
    String bairro,
    String cidade,
    String estado, // ou UF, dependendo da sua modelagem
  ) async {
    try {
      String fullAddress = '$logradouro, $numero, $bairro, $cidade, $estado';
      List<Location> locations = await locationFromAddress(fullAddress);

      if (locations.isNotEmpty) {
        return LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
      } else {
        throw Exception(
            'Não foi possível obter as coordenadas para o endereço: $fullAddress');
      }
    } catch (e) {
      log('Erro ao calcular LatLng: $e');
      rethrow;
    }
  }

  Future<void> register() async {
    log('----state atualizado----');
    log('${state.selectedTypes}');
    log('${state.selectedServices}');
    log(state.cep);
    log(state.logradouro);
    log(state.numero);
    log(state.bairro);
    log(state.cidade);
    final NewSpaceRegisterState(
      :selectedTypes,
      :selectedServices,
      :imageFiles,
      :cep,
      :logradouro,
      :numero,
      :bairro,
      :cidade,
    ) = state;

    final spaceId = uuid.v4();
    final userId = user.uid;

    final LatLng latLng =
        await calculateLatLng(logradouro, numero, bairro, cidade, 'RJ');

    final spaceData = (
      spaceId: spaceId,
      userId: userId,
      titulo: 'teste',
      cep: cep,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
      selectedTypes: selectedTypes,
      selectedServices: selectedServices,
      imageFiles: imageFiles,
      descricao: 'teste',
      city: 'teste',
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );

    final spaceFirestoreRepository = ref.read(spaceFirestoreRepositoryProvider);

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
