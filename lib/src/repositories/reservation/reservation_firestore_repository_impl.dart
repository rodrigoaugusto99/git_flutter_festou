import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';

import 'package:git_flutter_festou/src/core/fp/either.dart';

import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
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
      String spaceId,
      String range,
    }) reservationData,
  ) async {
    final currentDateTime = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy - HH');
    final formattedDateTime = dateFormat.format(currentDateTime);
    try {
      Map<String, dynamic> newReservation = {
        'user_id': reservationData.userId,
        'space_id': reservationData.spaceId,
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

  @override
  Future<Either<RepositoryException, List<ReservationModel>>> getReservations(
      String spaceId) async {
    try {
      final allReservationsDocuments = await reservationCollection
          .where('space_id', isEqualTo: spaceId)
          .get();

      List<ReservationModel> reservationModels =
          allReservationsDocuments.docs.map((reservationModels) {
        return mapReservationDocumentToModel(reservationModels);
      }).toList();
      return Success(reservationModels);
    } catch (e) {
      log('Erro ao recuperar as reservas do firestore: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar as reservas'));
    }
  }

  ReservationModel mapReservationDocumentToModel(
      QueryDocumentSnapshot reservationDocument) {
    return ReservationModel(
      spaceId: reservationDocument['space_id'] ?? '',
      userId: reservationDocument['user_id'] ?? '',
      range: reservationDocument['range'] ?? '',
      date: reservationDocument['date'] ?? '',
    );
  }
}
