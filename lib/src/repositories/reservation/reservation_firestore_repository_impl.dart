import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';

import 'package:git_flutter_festou/src/core/fp/either.dart';

import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:intl/intl.dart';

import './reservation_firestore_repository.dart';

class ReservationFirestoreRepositoryImpl
    implements ReservationFirestoreRepository {
  final CollectionReference reservationCollection =
      FirebaseFirestore.instance.collection('reservations');
  @override
  Future<Either<RepositoryException, Nil>> saveReservation(
    ({
      String userId,
      String reservationId,
      String range,
    }) reservationData,
  ) async {
    final currentDateTime = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy - HH');
    final formattedDateTime = dateFormat.format(currentDateTime);
    try {
      Map<String, dynamic> newReservation = {
        'user_id': reservationData.userId,
        'space_id': reservationData.reservationId,
        'range': reservationData.range,
        'date': formattedDateTime,
      };

      await reservationCollection.add(newReservation);
      log('Reserva feita com sucesso!');

      return Success(nil);
    } catch (e) {
      log('Erro ao reservar espaço: $e');
      return Failure(RepositoryException(message: 'Erro ao avaliar espaço'));
    }
  }
}
