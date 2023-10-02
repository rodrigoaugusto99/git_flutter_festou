import 'dart:developer';
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
    String name,
    String email,
    String cep,
    String endereco,
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
      endereco: endereco,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
      selectedTypes: selectedTypes,
      availableDays: availableDays,
      selectedServices: selectedServices,
    );

    final spaceRegister = ref.watch(spaceRepositoryProvider);
    log('$spaceData');
    final registerResult = spaceRegister.save(spaceData);

    switch (registerResult) {
      case Success():
        break;
      case Failure():
        break;
    }
  }
}
