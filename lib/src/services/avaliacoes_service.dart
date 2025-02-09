import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Festou/src/core/exceptions/repository_exception.dart';
import 'package:Festou/src/models/avaliacoes_model.dart';

class AvaliacoesService {
  User? currUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<AvaliacoesModel?> getFeedbackById(String feedbackId) async {
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

  Future<List<AvaliacoesModel>> deleteFeedbackByCondition(
      String feedbackId, String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('feedbacks')
          .where('id', isEqualTo: feedbackId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('feedbacks')
            .doc(snapshot.docs.first.id)
            .update({'deletedAt': FieldValue.serverTimestamp()});

        log('Feedback com ID $feedbackId foi excluído com sucesso.');

        // Retorna os feedbacks atualizados para atualizar a UI
        return await getMyFeedbacks(userId);
      } else {
        log('Nenhum feedback encontrado com o ID fornecido.');
        return [];
      }
    } catch (e) {
      log('Erro ao excluir feedback: $e');
      rethrow;
    }
  }

  AvaliacoesModel mapFeedbackDocumentToModel(
      QueryDocumentSnapshot feedbackDocument) {
    List<String> likes = List<String>.from(feedbackDocument['likes'] ?? []);
    List<String> dislikes =
        List<String>.from(feedbackDocument['dislikes'] ?? []);
    return AvaliacoesModel(
      spaceId: feedbackDocument['space_id'] ?? '',
      userId: feedbackDocument['user_id'] ?? '',
      reservationId: feedbackDocument['reservationId'] ?? '',
      deletedAt: feedbackDocument['deletedAt'],
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

  Future<String> checkUserReaction(String feedbackId) async {
    try {
      // Obtenha o documento específico pelo feedbackId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('feedbacks')
          .where("id", isEqualTo: feedbackId)
          .get();

      if (querySnapshot.docs.length == 1) {
        final userDocument = querySnapshot.docs.first;
        final currentLikes = List<String>.from(userDocument['likes'] ?? []);
        final currentDislikes =
            List<String>.from(userDocument['dislikes'] ?? []);

        // Verifique se o user.uid está presente nos likes ou dislikes
        if (currentLikes.contains(currUser!.uid)) {
          return 'isLiked';
        } else if (currentDislikes.contains(currUser!.uid)) {
          return 'isDisliked';
        } else {
          return '';
        }
      } else {
        log('Nenhum documento desse feedback foi encontrado, ou mais de 1 foram encontrados.');
        return '';
      }
    } catch (e) {
      log('Erro ao verificar a reação do usuário: $e');
      return '';
    }
  }

  Future toggleDislikeFeedback(String feedbackId) async {
    try {
      // Obtenha o documento específico pelo feedbackId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('feedbacks')
          .where("id", isEqualTo: feedbackId)
          .get();

      if (querySnapshot.docs.length == 1) {
        final userDocument = querySnapshot.docs.first;
        final currentLikes = List<String>.from(userDocument['likes'] ?? []);
        final currentDislikes =
            List<String>.from(userDocument['dislikes'] ?? []);

        // Remova o like se o usuário já deu like
        if (currentLikes.contains(currUser!.uid)) {
          userDocument.reference.update({
            'likes': FieldValue.arrayRemove([currUser!.uid]),
          });
        }

        if (currentDislikes.contains(currUser!.uid)) {
          // Se o user.uid já está presente, removê-lo do array
          userDocument.reference.update({
            'dislikes': FieldValue.arrayRemove([currUser!.uid]),
          });
        } else {
          // Se o user.uid não está presente, adicioná-lo ao array
          userDocument.reference.update({
            'dislikes': FieldValue.arrayUnion([currUser!.uid]),
          });
        }
      } else {
        log('Nenhum documento desse feedback foi encontrado, ou mais de 1 foram encontrados.');
      }
    } catch (e) {
      log('Erro ao alternar o dislike: $e');
    }
  }

  Future toggleLikeFeedback(String feedbackId) async {
    try {
      // Obtenha o documento específico pelo feedbackId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('feedbacks')
          .where("id", isEqualTo: feedbackId)
          .get();

      if (querySnapshot.docs.length == 1) {
        final userDocument = querySnapshot.docs.first;
        final currentLikes = List<String>.from(userDocument['likes'] ?? []);
        final currentDislikes =
            List<String>.from(userDocument['dislikes'] ?? []);

        // Remova o dislike se o usuário já deu dislike
        if (currentDislikes.contains(currUser!.uid)) {
          userDocument.reference.update({
            'dislikes': FieldValue.arrayRemove([currUser!.uid]),
          });
        }

        if (currentLikes.contains(currUser!.uid)) {
          // Se o user.uid já está presente, removê-lo do array
          userDocument.reference.update({
            'likes': FieldValue.arrayRemove([currUser!.uid]),
          });
        } else {
          // Se o user.uid não está presente, adicioná-lo ao array
          userDocument.reference.update({
            'likes': FieldValue.arrayUnion([currUser!.uid]),
          });
        }
      } else {
        log('Nenhum documento desse feedback foi encontrado, ou mais de 1 foram encontrados.');
      }
    } catch (e) {
      log('Erro ao alternar o like: $e');
    }
  }

  Future<List<AvaliacoesModel>> getMyFeedbacks(String userId) async {
    try {
      final allFeedbacksDocuments = await FirebaseFirestore.instance
          .collection('feedbacks')
          .where('user_id', isEqualTo: userId)
          .get();

      List<AvaliacoesModel> feedbackModels =
          allFeedbacksDocuments.docs.map((feedbackDocument) {
        return mapFeedbackDocumentToModel(feedbackDocument);
      }).toList();
      return feedbackModels;
    } catch (e) {
      log('Erro ao recuperar os meus feeedbacks do firestore: $e');
      throw RepositoryException(message: 'Erro ao carregar os meus feedbacks');
    }
  }

  Future<List<AvaliacoesModel>> getFeedbacksOrdered(String spaceId) async {
    try {
      QuerySnapshot allFeedbacksDocuments = await FirebaseFirestore.instance
          .collection('feedbacks')
          .where('space_id', isEqualTo: spaceId)
          .orderBy('date', descending: true)
          .get();

      List<AvaliacoesModel> feedbackModels =
          allFeedbacksDocuments.docs.map((feedbackDocument) {
        return mapFeedbackDocumentToModel(feedbackDocument);
      }).toList();
      return feedbackModels;
    } catch (e) {
      log('Erro ao recuperar os feeedbacks do firestore: $e');
      throw RepositoryException(message: 'Erro ao carregar os feedbacks');
    }
  }

  void cancelSpaceSubscription() {
    spaceFeedbacksSubscription?.cancel();
  }

  StreamSubscription? spaceFeedbacksSubscription;

  Future<void> setSpaceFeedbacksListener(
    String spaceId,
    void Function(List<AvaliacoesModel> feedbacks) onNewSnapshot,
  ) async {
    final query = FirebaseFirestore.instance
        .collection('feedbacks')
        .where('space_id', isEqualTo: spaceId)
        .orderBy('date', descending: true);

    spaceFeedbacksSubscription =
        query.snapshots().skip(1).listen((snapshot) async {
      if (snapshot.docs.isEmpty) return;

      List<AvaliacoesModel> feedbackModels =
          snapshot.docs.map((feedbackDocument) {
        return mapFeedbackDocumentToModel(feedbackDocument);
      }).toList();

      onNewSnapshot(feedbackModels);
    });
  }
}
