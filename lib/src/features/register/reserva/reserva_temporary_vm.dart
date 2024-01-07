
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/features/register/reserva/reserva_register_state.dart';
import 'package:git_flutter_festou/src/features/register/reserva/reserva_register_vm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'reserva_temporary_vm.g.dart';

@riverpod
class ReservaTemporaryVm extends _$ReservaTemporaryVm {
  final uuid = const Uuid();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Future<ReservationRegisterState> build() async {
    final reservationStateTemporary = ref.watch(reservationRegisterVmProvider);

    try {
      switch (reservationStateTemporary) {
        case Success():
          return ReservationRegisterState(
              status: ReservationRegisterStateStatus.success, range: '');

        case Failure(exception: RepositoryException(:final message)):
          return ReservationRegisterState(
            status: ReservationRegisterStateStatus.error,
            range: '',
            errorMessage: message,
          );
      }
    } on Exception {
      return ReservationRegisterState(
        status: ReservationRegisterStateStatus.error,
        range: '',
        errorMessage: 'erro desconhecido',
      );
    }
    return ReservationRegisterState(
        status: ReservationRegisterStateStatus.error, range: '');
  }
}
