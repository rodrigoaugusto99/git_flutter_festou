import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:festou/src/core/exceptions/repository_exception.dart';
import 'package:festou/src/core/fp/either.dart';
import 'package:festou/src/core/providers/application_providers.dart';
import 'package:festou/src/features/register/space/space%20temporary/pages/new_space_register_state.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:validatorless/validatorless.dart';
import 'package:video_player/video_player.dart';

part 'new_space_register_vm.g.dart';

@riverpod
class NewSpaceRegisterVm extends _$NewSpaceRegisterVm {
  @override
  NewSpaceRegisterState build() => NewSpaceRegisterState.initial();
  final uuid = const Uuid();
  final user = FirebaseAuth.instance.currentUser!;

  NewSpaceRegisterState getState() {
    return state;
  }

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

  bool validatePreco(String preco) {
    if (preco.isEmpty) {
      return false;
    } else {
      state = state.copyWith(
        status: NewSpaceRegisterStateStatus.success,
        preco: preco,
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
      log(state.preco);
      return true;
    }
  }

  bool validateDiaEHoras({
    required Days days,
  }) {
    state = state.copyWith(
      status: NewSpaceRegisterStateStatus.success,
      days: days,
    );
    log('----state atualizado----');
    log('${state.selectedTypes}');
    log('${state.selectedServices}');
    log(state.cep, name: 'cpf');
    log(state.logradouro, name: 'logradouro');
    log(state.numero, name: 'numero');
    log(state.bairro, name: 'bairro');
    log(state.cidade, name: 'cidade');
    log(state.titulo, name: 'titulo');
    log(state.preco, name: 'preco');

    log(state.days.toString(), name: 'days');
    return true;
  }

  bool validateDescricao(String descricao) {
    if (descricao.isEmpty) {
      return false;
    } else {
      state = state.copyWith(
        status: NewSpaceRegisterStateStatus.success,
        descricao: descricao,
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
    return Validatorless.required('CEP obrigatório');
  }

  FormFieldValidator<String> validateLogradouro() {
    return Validatorless.required('Logradouro obrigatório');
  }

  FormFieldValidator<String> validateNumero() {
    return Validatorless.required('Número obigatorio');
  }

  FormFieldValidator<String> validateBairro() {
    return Validatorless.required('Bairro obrigatório');
  }

  FormFieldValidator<String> validateCidade() {
    return Validatorless.required('Cidade obrigatório');
  }

  FormFieldValidator<String> validateEstado() {
    return Validatorless.required('Estado obrigatório');
  }

  Future<String?> validateForm(
    BuildContext context,
    formKey,
    cepEC,
    logradouroEC,
    numeroEC,
    bairroEC,
    cidadeEC,
    estadoEC,
  ) async {
    if (formKey.currentState?.validate() == true) {
      try {
        final response = await calculateLatLng(logradouroEC.text, numeroEC.text,
            bairroEC.text, cidadeEC.text, estadoEC.text);
        log(response.toString(), name: 'response do calculateLtn');
      } on Exception catch (e) {
        log(e.toString());
        state = state.copyWith(status: NewSpaceRegisterStateStatus.invalidForm);
        return 'Localização não existe';
      }

      state = state.copyWith(
        status: NewSpaceRegisterStateStatus.success,
        cep: cepEC.text,
        logradouro: logradouroEC.text,
        numero: numeroEC.text,
        bairro: bairroEC.text,
        cidade: cidadeEC.text,
        estado: estadoEC.text,
      );
      log('----state atualizado----');
      log('${state.selectedTypes}');
      log('${state.selectedServices}');
      log(state.cep);
      log(state.logradouro);
      log(state.numero);
      log(state.bairro);
      log(state.cidade);
      log(state.estado);
      return null;
    } else {
      state = state.copyWith(status: NewSpaceRegisterStateStatus.invalidForm);
      return 'Formulário invalido';
    }
  }

  List<File> get imageFiles => state.imageFiles;
  List<File> get videos => state.videoFiles;

  Future<int> pickImage() async {
    final imagePicker = ImagePicker();
    final List<XFile> images = await imagePicker.pickMultiImage();

    final List<File> newImages = images.map((img) => File(img.path)).toList();

    state = state.copyWith(
      imageFiles: [
        ...state.imageFiles,
        ...newImages
      ], // Mantendo as imagens adicionadas
      status: NewSpaceRegisterStateStatus.success,
    );

    log('📸 Imagens adicionadas: ${state.imageFiles.length}');
    return state.imageFiles.length;
  }

  final List<VideoPlayerController> localControllers = [];

  Future<void> pickVideo() async {
    final videoPicker = ImagePicker();
    final XFile? video =
        await videoPicker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      final File videoFile = File(video.path);

      videos.add(videoFile);

      VideoPlayerController controller = VideoPlayerController.file(videoFile);
      await controller.initialize();

      localControllers.add(controller);

      state = state.copyWith(
        videoFiles: [...videos],
        status: NewSpaceRegisterStateStatus.success,
      );

      log('🎥 Vídeo adicionado! Total de vídeos: ${state.videoFiles.length}');
    }
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

  void reset() {
    state = NewSpaceRegisterState.initial().copyWith(
      selectedTypes: [],
      selectedServices: [],
      imageFiles: [],
      videoFiles: [],
      titulo: '',
      descricao: '',
      preco: '',
      cep: '',
      logradouro: '',
      numero: '',
      bairro: '',
      cidade: '',
      estado: '',
      days: Days(
        monday: null,
        tuesday: null,
        wednesday: null,
        thursday: null,
        friday: null,
        saturday: null,
        sunday: null,
      ), // Resetando os horários
    );

    log('🔄 Estado resetado para um novo cadastro!');
  }

  Future<void> register() async {
    // log('----state atualizado----');
    // log('${state.selectedTypes}');
    // log('${state.selectedServices}');
    // log(state.cep);
    // log(state.logradouro);
    // log(state.numero);
    // log(state.bairro);
    // log(state.cidade);
    // log(state.preco);
    final NewSpaceRegisterState(
      :selectedTypes,
      :selectedServices,
      :imageFiles,
      :cep,
      :logradouro,
      :numero,
      :bairro,
      :cidade,
      :days,
      :descricao,
      :titulo,
      :preco,
      :estado,
      :videoFiles,
    ) = state;

    final spaceId = uuid.v4();
    final userId = user.uid;
    // UserModel? userModel = await UserService().getCurrentUserModel();

    final LatLng latLng =
        await calculateLatLng(logradouro, numero, bairro, cidade, estado);

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
      videoFiles: videoFiles,
      descricao: descricao,
      estado: estado,
      days: days!,
      //city: 'teste',
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      preco: preco,
      // cnpjEmpresaLocadora: userModel != null ? userModel.name : '',
      // locadorCpf: userModel != null ? userModel.name : '',
      // nomeEmpresaLocadora: userModel != null ? userModel.name : '',
      // locadorAssinatura: userModel != null ? userModel.name : '',
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
