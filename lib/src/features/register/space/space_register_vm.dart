import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    log('state atualizado');
  }

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

  Future<void> validateForm(BuildContext context, formKey, tituloEC, cepEC,
      logradouroEC, numeroEC, bairroEC, cidadeEC, descricaoEC, cityEC) async {
    if (formKey.currentState?.validate() == true) {
      await register(
        tituloEC.text,
        cepEC.text,
        logradouroEC.text,
        numeroEC.text,
        bairroEC.text,
        cidadeEC.text,
        descricaoEC.text,
        cityEC.text,
      );
    } else {
      state = state.copyWith(status: SpaceRegisterStateStatus.invalidForm);
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
      status: SpaceRegisterStateStatus.error,
    );
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

//todo: substituir o "RJ" por UF correto do usuario
  Future<void> register(
    String titulo,
    String cep,
    String logradouro,
    String numero,
    String bairro,
    String cidade,
    String descricao,
    String city,
  ) async {
    //final SpaceRegisterState(:selectedTypes, :selectedServices, :imageFiles) =
    state;

    /*final LatLng latLng =
        await calculateLatLng(logradouro, numero, bairro, cidade, 'RJ');

    final spaceId = uuid.v4();
    final userId = user.uid;
    final spaceData = (
      spaceId: spaceId,
      userId: userId,
      titulo: titulo,
      cep: cep,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
      selectedTypes: selectedTypes,
      selectedServices: selectedServices,
      imageFiles: imageFiles,
      descricao: descricao,
      city: city,
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );*/
  }
}
