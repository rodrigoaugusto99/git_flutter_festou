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

  void addToState(String newRnge) {
    state = state.copyWith(
      range: newRnge,
      status: ReservationRegisterStateStatus.initial,
    );
  }

  Future<void> register() async {
    final ReservationRegisterState(:range) = state;

    final reservationId = uuid.v4();
    final userId = user.uid;
    final reservationData = (
      userId: userId,
      reservationId: reservationId,
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
