import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'space_register_vm.g.dart';

@riverpod
class SpaceRegisterVm extends _$SpaceRegisterVm {
  @override
  SpaceRegisterState build() => SpaceRegisterState.initial();

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
    User user,
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

    final spaceData = (
      name: name,
      email: email,
      cep: cep,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
      user: user,
      selectedTypes: selectedTypes,
      availableDays: availableDays,
      selectedServices: selectedServices,
    );

    final spaceRepository = ref.watch(spaceRepositoryProvider);
    log('Registrando espaço: $spaceData');
    final registerResult = spaceRepository.save(spaceData);

    switch (registerResult) {
      case Success():
        break;
      case Failure():
        break;
    }
  }
}
