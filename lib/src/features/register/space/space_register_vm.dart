import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

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

    state = state.copyWith(availableDays: availableDays);
  }

  void addOrRemoveType(String type) {
    final selectedTypes = state.selectedTypes;

    if (selectedTypes.contains(type)) {
      selectedTypes.remove(type);
    } else {
      selectedTypes.add(type);
    }

    state = state.copyWith(selectedTypes: selectedTypes);
  }

  void addOrRemoveService(String service) {
    final selectedServices = state.selectedServices;

    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }

    state = state.copyWith(selectedServices: selectedServices);
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
    ) = state;

    final spaceId = uuid.v4();
    final userId = user.uid;

    final space = (
      spaceId: spaceId,
      name: name,
      email: email,
      userId: userId,
    );

    final spaceAddress = (
      cep: cep,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
      spaceId: spaceId,
    );
    final spaceInfos = (
      selectedTypes: selectedTypes,
      availableDays: availableDays,
      selectedServices: selectedServices,
      spaceId: spaceId,
    );

    final spaceFirestoreRepository =
        ref.watch(spaceFirestoreRepositoryProvider);
    log('Registrando espaço: $space');
    final registerResultSpace = spaceFirestoreRepository.saveSpace(space);
    //todo: esses dois - entrar no switch
    final registerResultSpaceAddress =
        spaceFirestoreRepository.saveSpaceAddress(spaceAddress);
    final registerResultSpaceInfos =
        spaceFirestoreRepository.saveSpaceInfos(spaceInfos);

    switch (registerResultSpace) {
      case Success():
        break;
      case Failure():
        break;
    }
  }
}
