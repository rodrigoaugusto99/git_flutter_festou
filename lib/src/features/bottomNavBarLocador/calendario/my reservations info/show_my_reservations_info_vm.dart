import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/my%20reservations%20info/show_my_reservations_info_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'show_my_reservations_info_vm.g.dart';

@riverpod
class ShowMyReservationsInfosVm extends _$ShowMyReservationsInfosVm {
  String errorMessage = '';
  @override
  Future<ShowMyReservationsInfosState> build(String userId) async {
    final userRepository = ref.watch(userFirestoreRepositoryProvider);

    try {
      final userResult = await userRepository.getUserById(userId);

      switch (userResult) {
        case Success(value: final userData):
          return ShowMyReservationsInfosState(
              status: ShowMyReservationsInfosStateStatus.loaded,
              user: userData);

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;
          return ShowMyReservationsInfosState(
            status: ShowMyReservationsInfosStateStatus.error,
          );
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';

      return ShowMyReservationsInfosState(
          status: ShowMyReservationsInfosStateStatus.loaded);
    }
  }
}
