import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/filter/filter_and_order_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_and_order_vm.g.dart';

@riverpod
class FilterAndOrderVm extends _$FilterAndOrderVm {
  String errorMessage = '';
  @override
  FilterAndOrderState build() => FilterAndOrderState.initial();

  void addOrRemoveAvailableDay(String weekDay) {
    final availableDays = state.availableDays;

    if (availableDays.contains(weekDay)) {
      availableDays.remove(weekDay);
    } else {
      availableDays.add(weekDay);
    }

    state = state.copyWith(
        availableDays: availableDays,
        status: FilterAndOrderStateStatus.initial);
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
        status: FilterAndOrderStateStatus.initial);
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
        status: FilterAndOrderStateStatus.initial);
  }

  Future<void> filter() async {
    final FilterAndOrderState(
      :selectedTypes,
      :availableDays,
      :selectedServices,
    ) = state;

    final filterData = (
      selectedTypes: selectedTypes,
      availableDays: availableDays,
      selectedServices: selectedServices,
    );

    final spaceFirestoreRepository = ref.read(spaceFirestoreRepositoryProvider);

    final filterResultSpace =
        await spaceFirestoreRepository.getFilteredSpaces(filterData);

    switch (filterResultSpace) {
      case Success():
        state = state.copyWith(status: FilterAndOrderStateStatus.success);
        break;
      case Failure(exception: RepositoryException()):
        state = state.copyWith(
          status: FilterAndOrderStateStatus.error,
        );
    }
  }
}
