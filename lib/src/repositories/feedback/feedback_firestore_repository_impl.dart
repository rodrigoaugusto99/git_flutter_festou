import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/feedback_model.dart';
import 'package:intl/intl.dart';
import './feedback_firestore_repository.dart';

class FeedbackFirestoreRepositoryImpl implements FeedbackFirestoreRepository {
  final CollectionReference feedbacksCollection =
      FirebaseFirestore.instance.collection('feedbacks');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Future<Either<RepositoryException, Nil>> saveFeedback(
    ({
      String spaceId,
      String userId,
      int rating,
      String content,
    }) feedbackData,
  ) async {
    // Crie um mapa com os dados passados como parâmetros
    log('entrou');
    String userName = await getUserName();
    final currentDateTime = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy - HH');
    final formattedDateTime = dateFormat.format(currentDateTime);
    try {
      Map<String, dynamic> newFeedback = {
        'space_id': feedbackData.spaceId,
        'user_id': feedbackData.userId,
        'rating': feedbackData.rating,
        'content': feedbackData.content,
        'user_name': userName,
        'date': formattedDateTime,
      };
      log('ntrou');
      await feedbacksCollection.add(newFeedback);
      log('Avaliação adicionado com sucesso!');
      return Success(nil);
    } catch (e) {
      log('Erro ao avaliar espaço: $e');
      return Failure(RepositoryException(message: 'Erro ao avaliar espaço'));
    }
  }

  @override
  Future<Either<RepositoryException, List<FeedbackModel>>> getFeedbacks(
      String spaceId) async {
    try {
      final allFeedbacksDocuments =
          await feedbacksCollection.where('space_id', isEqualTo: spaceId).get();

      List<FeedbackModel> feedbackModels =
          allFeedbacksDocuments.docs.map((feedbackDocument) {
        return mapFeedbackDocumentToModel(feedbackDocument);
      }).toList();
      return Success(feedbackModels);
    } catch (e) {
      log('Erro ao recuperar os feeedbacks do firestore: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar os feedbacks'));
    }
  }

  FeedbackModel mapFeedbackDocumentToModel(
      QueryDocumentSnapshot feedbackDocument) {
    return FeedbackModel(
      spaceId: feedbackDocument['space_id'] ?? '',
      userId: feedbackDocument['user_id'] ?? '',
      rating: feedbackDocument['rating'] ?? 0,
      content: feedbackDocument['content'] ?? '',
      userName: feedbackDocument['user_name'] ?? '',
      date: feedbackDocument['date'] ?? '',
    );
  }

  Future<String> getUserName() async {
    final userDocument = await getUserDocument();
    if (userDocument.exists) {
      final userData = userDocument.data() as Map<String, dynamic>;
      final name = userData['nome'];

      return name.toString();
    }
    // Trate o caso em que o documento não contém o campo "name" ou não existe.
    throw Exception("Nome do usuário não encontrado");
  }

  Future<DocumentSnapshot> getUserDocument() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    throw Exception("Usuário não encontrado");
  }
}
