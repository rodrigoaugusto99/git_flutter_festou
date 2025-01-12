import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_flutter_festou/src/models/feedback_model.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<FeedbackModel?> getFeedbackById(String feedbackId) async {
    try {
      // Obtém o documento na coleção "feedbacks" pelo ID fornecido
      final snapshot = await _firestore
          .collection('feedbacks')
          .where('id', isEqualTo: feedbackId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Retorna os dados do feedback
        final feedback = mapFeedbackDocumentToModel(snapshot.docs[0]);
        return feedback;
      } else {
        // Caso o documento não exista, retorna nulo
        return null;
      }
    } catch (e) {
      // Em caso de erro, imprime o erro e retorna nulo
      log('Erro ao obter feedback: $e');
      return null;
    }
  }

  Future<void> updateFeedbackContent(String id, String newContent) async {
    try {
      // Procura pelo documento com a condição especificada
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('feedbacks')
          .where('id', isEqualTo: id)
          .get();

      // Garante que existe pelo menos um documento correspondente
      if (snapshot.docs.isNotEmpty) {
        // Obtém o ID do primeiro documento encontrado
        String docId = snapshot.docs.first.id;

        // Atualiza o documento
        await FirebaseFirestore.instance
            .collection('feedbacks')
            .doc(docId)
            .update({'content': newContent});
      } else {
        log('Nenhum feedback encontrado com o ID fornecido.');
      }
    } catch (e) {
      log('Erro ao atualizar feedback: $e');
      rethrow;
    }
  }

  FeedbackModel mapFeedbackDocumentToModel(
      QueryDocumentSnapshot feedbackDocument) {
    List<String> likes = List<String>.from(feedbackDocument['likes'] ?? []);
    List<String> dislikes =
        List<String>.from(feedbackDocument['dislikes'] ?? []);
    return FeedbackModel(
      spaceId: feedbackDocument['space_id'] ?? '',
      userId: feedbackDocument['user_id'] ?? '',
      rating: feedbackDocument['rating'] ?? 0,
      content: feedbackDocument['content'] ?? '',
      userName: feedbackDocument['user_name'] ?? '',
      date: feedbackDocument['date'] ?? '',
      avatar: feedbackDocument['avatar'] ?? '',
      likes: likes,
      dislikes: dislikes,
      id: feedbackDocument['id'] ?? '',
    );
  }
}
