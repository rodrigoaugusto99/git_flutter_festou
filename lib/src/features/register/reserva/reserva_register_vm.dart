import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/register/reserva/reserva_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'reserva_register_vm.g.dart';

@riverpod
class ReservationRegisterVm extends _$ReservationRegisterVm {
  @override
  ReservationRegisterState build() => ReservationRegisterState.initial();

  final uuid = const Uuid();
  final user = FirebaseAuth.instance.currentUser!;

  void addToState(String newRange) {
    state = state.copyWith(
      range: newRange,
      status: ReservationRegisterStateStatus.initial,
    );
    log('estado do range: ${state.range}');
  }

  Future<void> register(String spaceId) async {
    final ReservationRegisterState(:range) = state;

    final userId = user.uid;
    final reservationData = (
      userId: userId,
      spaceId: spaceId,
      range: range,
    );

    final reservationFirestoreRepository =
        ref.read(reservationFirestoreRepositoryProvider);

    final result =
        await reservationFirestoreRepository.saveReservation(reservationData);

    switch (result) {
      case Success():
        state = state.copyWith(status: ReservationRegisterStateStatus.success);

        break;
      case Failure(exception: RepositoryException(:final message)):
        state = state.copyWith(
          status: ReservationRegisterStateStatus.error,
          errorMessage: () => message,
        );
    }
  }
}
