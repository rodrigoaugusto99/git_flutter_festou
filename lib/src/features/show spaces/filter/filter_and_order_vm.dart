import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/filter_and_order_state.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_and_order_vm.g.dart';

@riverpod
class FilterAndOrderVm extends _$FilterAndOrderVm {
  List<SpaceWithImages> spacesFilterType = [];
  List<SpaceWithImages> spacesFilterService = [];
  List<SpaceWithImages> spacesFilterDays = [];
  String errorMessage = '';

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

  void redefinir() {
    state = state.copyWith(
      status: FilterAndOrderStateStatus.initial,
      selectedServices: [],
      selectedTypes: [],
      availableDays: [],
    );
  }

  @override
  FilterAndOrderState build() => FilterAndOrderState.initial();

  Future<void> filter() async {
    final FilterAndOrderState(
      :selectedTypes,
      :availableDays,
      :selectedServices,
    ) = state;

    final spaceFirestoreRepository = ref.read(spaceFirestoreRepositoryProvider);

    final filterResultSpaceByType = await spaceFirestoreRepository
        .getSpacesBySelectedTypes(selectedTypes: selectedTypes);

    switch (filterResultSpaceByType) {
      case Success(value: final filteredSpacesData):
        spacesFilterType = filteredSpacesData;
        break;
      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: FilterAndOrderStateStatus.error,
          filteredSpaces: [],
          errorMessage: () => message,
        );
    }

    final filterResultSpaceByService =
        await spaceFirestoreRepository.getSpacesBySelectedServices(
      selectedServices: selectedServices,
    );

    switch (filterResultSpaceByService) {
      case Success(value: final filteredSpacesData):
        spacesFilterService = filteredSpacesData;
        break;
      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: FilterAndOrderStateStatus.error,
          filteredSpaces: [],
          errorMessage: () => message,
        );
    }
    final filterResultSpaceByDay =
        await spaceFirestoreRepository.getSpacesByAvailableDays(
      availableDays: availableDays,
    );

    switch (filterResultSpaceByDay) {
      case Success(value: final filteredSpacesData):
        spacesFilterDays = filteredSpacesData;
        break;
      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: FilterAndOrderStateStatus.error,
          filteredSpaces: [],
          errorMessage: () => message,
        );
    }

    final spaces = await spaceFirestoreRepository.filterSpaces(
        spacesFilterType, spacesFilterService, spacesFilterDays);

    switch (spaces) {
      case Success(value: final filteredSpacesData):
        state = state.copyWith(
          status: FilterAndOrderStateStatus.success,
          filteredSpaces: filteredSpacesData,
        );
        break;
      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: FilterAndOrderStateStatus.error,
          filteredSpaces: [],
          errorMessage: () => message,
        );
    }
  }
}
