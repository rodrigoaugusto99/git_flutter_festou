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

  final CollectionReference hostFeedbacksCollection =
      FirebaseFirestore.instance.collection('host_feedbacks');

  final CollectionReference guestFeedbacksCollection =
      FirebaseFirestore.instance.collection('guest_feedbacks');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

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
    String userAvatar = await getUserAvatar();
    final currentDateTime = DateTime.now();
    log(currentDateTime.toString());
    final dateFormat = DateFormat('dd/MM/yyyy');
    log(dateFormat.toString());
    final formattedDateTime = dateFormat.format(currentDateTime);
    log(formattedDateTime.toString());
    try {
      Map<String, dynamic> newFeedback = {
        'space_id': feedbackData.spaceId,
        'user_id': feedbackData.userId,
        'rating': feedbackData.rating,
        'content': feedbackData.content,
        'user_name': userName,
        'date': formattedDateTime,
        'avatar': userAvatar,
      };
      log('ntrou');
      await feedbacksCollection.add(newFeedback);
      log('Avaliação adicionado com sucesso!');
      // Após adicionar o feedback, atualize a média no espaço correspondente
      await updateAverageRating(feedbackData.spaceId);
      await updateNumComments(feedbackData.spaceId);
      return Success(nil);
    } catch (e) {
      log('Erro ao avaliar espaço: $e');
      return Failure(RepositoryException(message: 'Erro ao avaliar espaço'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> saveHostFeedback(
    ({
      String hostId,
      String userId,
      int rating,
      String content,
    }) feedbackData,
  ) async {
    // Crie um mapa com os dados passados como parâmetros
    log('entrou');
    String userName = await getUserName();
    String userAvatar = await getUserAvatar();
    final currentDateTime = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy - HH');
    final formattedDateTime = dateFormat.format(currentDateTime);
    try {
      Map<String, dynamic> newFeedback = {
        'host_id': feedbackData.hostId,
        'user_id': feedbackData.userId,
        'rating': feedbackData.rating,
        'content': feedbackData.content,
        'user_name': userName,
        'date': formattedDateTime,
        'avatar': userAvatar,
      };
      log('ntrou');
      await hostFeedbacksCollection.add(newFeedback);
      log('Avaliação de host adicionado com sucesso!');
      // Após adicionar o feedback, atualize a média no espaço correspondente
      await updateHostAverageRating(feedbackData.hostId);
      await updateHostNumComments(feedbackData.hostId);
      return Success(nil);
    } catch (e) {
      log('Erro ao avaliar espaço: $e');
      return Failure(RepositoryException(message: 'Erro ao avaliar host'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> saveGuestFeedback(
      ({
        String content,
        String guestId,
        int rating,
        String userId
      }) feedbackData) async {
    log('entrou');
    String userName = await getUserName();
    String userAvatar = await getUserAvatar();
    final currentDateTime = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy - HH');
    final formattedDateTime = dateFormat.format(currentDateTime);
    try {
      Map<String, dynamic> newFeedback = {
        'guest_id': feedbackData.guestId,
        'user_id': feedbackData.userId,
        'rating': feedbackData.rating,
        'content': feedbackData.content,
        'user_name': userName,
        'date': formattedDateTime,
        'avatar': userAvatar,
      };
      log('ntrou');
      await guestFeedbacksCollection.add(newFeedback);
      log('Avaliação de guest adicionado com sucesso!');
      // Após adicionar o feedback, atualize a média no espaço correspondente
      await updateGuestAverageRating(feedbackData.guestId);
      await updateGuestNumComments(feedbackData.guestId);
      return Success(nil);
    } catch (e) {
      log('Erro ao avaliar guest: $e');
      return Failure(RepositoryException(message: 'Erro ao avaliar guest'));
    }
  }

// Função para calcular a numero de comntarioss e atualizar o campo average_rating no Firestore
  Future<void> updateNumComments(String spaceId) async {
    try {
      final allFeedbacksDocuments =
          await feedbacksCollection.where('space_id', isEqualTo: spaceId).get();

      // Verifica se há documentos reais na coleção
      if (allFeedbacksDocuments.size == 0) {
        // Não há feedbacks para o espaço fornecido
        log('Nenhum doc encontrado p o espaço com spaceId: $spaceId');
        return;
      }
      log('allFeedbacksDocuments: $allFeedbacksDocuments');
      log('spaceId: $spaceId');

      int totalDocuments = allFeedbacksDocuments.docs.length;

      await spacesCollection
          .where('space_id', isEqualTo: spaceId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference
              .update({'num_comments': totalDocuments.toString()});
          log('Numero de comntarios atualizado com sucesso!');
        } else {
          log('Nenhum documento encontrado para o espaço com space_id: $spaceId');
        }
      });
    } catch (e) {
      log('Erro ao atualizar numero de comntarios: $e');
    }
  }

  Future<void> updateHostNumComments(String hostId) async {
    try {
      final allFeedbacksDocuments = await hostFeedbacksCollection
          .where('host_id', isEqualTo: hostId)
          .get();

      // Verifica se há documentos reais na coleção
      if (allFeedbacksDocuments.size == 0) {
        // Não há feedbacks para o espaço fornecido
        log('Nenhum doc encontrado p o espaço com hostId: $hostId');
        return;
      }
      log('allFeedbacksDocuments: $allFeedbacksDocuments');
      log('hostId: $hostId');

      int totalDocuments = allFeedbacksDocuments.docs.length;

      await usersCollection
          .where('uid', isEqualTo: hostId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference
              .update({'num_comments': totalDocuments.toString()});
          log('Numero de comntarios atualizado com sucesso!');
        } else {
          log('Nenhum documento encontrado para o host com host_id: $hostId');
        }
      });
    } catch (e) {
      log('Erro ao atualizar numero de comntarios: $e');
    }
  }

  Future<void> updateGuestNumComments(String guestId) async {
    try {
      final allFeedbacksDocuments = await guestFeedbacksCollection
          .where('guest_id', isEqualTo: guestId)
          .get();

      // Verifica se há documentos reais na coleção
      if (allFeedbacksDocuments.size == 0) {
        // Não há feedbacks para o espaço fornecido
        log('Nenhum doc encontrado p o espaço com guestId: $guestId');
        return;
      }
      log('allFeedbacksDocuments: $allFeedbacksDocuments');
      log('hostId: $guestId');

      int totalDocuments = allFeedbacksDocuments.docs.length;

      await usersCollection
          .where('uid', isEqualTo: guestId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference
              .update({'num_comments': totalDocuments.toString()});
          log('Numero de comntarios atualizado com sucesso!');
        } else {
          log('Nenhum documento encontrado para o guest com host_id: $guestId');
        }
      });
    } catch (e) {
      log('Erro ao atualizar numero de comntarios: $e');
    }
  }

  // Função para calcular a média dos ratings e atualizar o campo average_rating no Firestore
  Future<void> updateAverageRating(String spaceId) async {
    try {
      final allFeedbacksDocuments =
          await feedbacksCollection.where('space_id', isEqualTo: spaceId).get();

      // Verifica se há documentos reais na coleção
      if (allFeedbacksDocuments.size == 0) {
        // Não há feedbacks para o espaço fornecido
        log('Nenhum doc encontrado p o espaço com spaceId: $spaceId');
        return;
      }
      log('allFeedbacksDocuments: $allFeedbacksDocuments');
      log('spaceId: $spaceId');

      int totalRating = 0;
      int totalDocuments = allFeedbacksDocuments.docs.length;

      for (QueryDocumentSnapshot document in allFeedbacksDocuments.docs) {
        // Obtém o valor de 'rating' do documento
        int rating = document['rating'];

        // Soma os ratings
        totalRating += rating;
      }

      // Calcula a média dos ratings
      double averageRating = totalRating / totalDocuments;

      // Atualiza o campo average_rating no documento do espaço com base no campo space_id
      await spacesCollection
          .where('space_id', isEqualTo: spaceId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference
              .update({'average_rating': averageRating.toString()});
          log('Average rating atualizado com sucesso!');
        } else {
          log('Nenhum documento encontrado para o espaço com space_id: $spaceId');
        }
      });
    } catch (e) {
      log('Erro ao atualizar average rating: $e');
    }
  }

  Future<void> updateHostAverageRating(String hostId) async {
    try {
      final allFeedbacksDocuments = await hostFeedbacksCollection
          .where('host_id', isEqualTo: hostId)
          .get();

      // Verifica se há documentos reais na coleção
      if (allFeedbacksDocuments.size == 0) {
        // Não há feedbacks para o espaço fornecido
        log('Nenhum doc encontrado p o host com hostId: $hostId');
        return;
      }
      log('allFeedbacksDocuments: $allFeedbacksDocuments');
      log('HostId: $hostId');

      int totalRating = 0;
      int totalDocuments = allFeedbacksDocuments.docs.length;

      for (QueryDocumentSnapshot document in allFeedbacksDocuments.docs) {
        // Obtém o valor de 'rating' do documento
        int rating = document['rating'];

        // Soma os ratings
        totalRating += rating;
      }

      // Calcula a média dos ratings
      double averageRating = totalRating / totalDocuments;

      // Atualiza o campo average_rating no documento do espaço com base no campo space_id
      await usersCollection
          .where('uid', isEqualTo: hostId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference
              .update({'average_rating': averageRating.toString()});
          log('Average rating atualizado com sucesso!');
        } else {
          log('Nenhum documento encontrado para o host com host_id: $hostId');
        }
      });
    } catch (e) {
      log('Erro ao atualizar average rating: $e');
    }
  }

  Future<void> updateGuestAverageRating(String guestId) async {
    try {
      final allFeedbacksDocuments = await guestFeedbacksCollection
          .where('guest_id', isEqualTo: guestId)
          .get();

      // Verifica se há documentos reais na coleção
      if (allFeedbacksDocuments.size == 0) {
        // Não há feedbacks para o espaço fornecido
        log('Nenhum doc encontrado p o host com guestId: $guestId');
        return;
      }
      log('allFeedbacksDocuments: $allFeedbacksDocuments');
      log('HostId: $guestId');

      int totalRating = 0;
      int totalDocuments = allFeedbacksDocuments.docs.length;

      for (QueryDocumentSnapshot document in allFeedbacksDocuments.docs) {
        // Obtém o valor de 'rating' do documento
        int rating = document['rating'];

        // Soma os ratings
        totalRating += rating;
      }

      // Calcula a média dos ratings
      double averageRating = totalRating / totalDocuments;

      // Atualiza o campo average_rating no documento do espaço com base no campo space_id
      await usersCollection
          .where('uid', isEqualTo: guestId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference
              .update({'average_rating': averageRating.toString()});
          log('Average rating atualizado com sucesso!');
        } else {
          log('Nenhum documento encontrado para o guest com guest_id: $guestId');
        }
      });
    } catch (e) {
      log('Erro ao atualizar average rating: $e');
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

  @override
  Future<Either<RepositoryException, List<FeedbackModel>>> getFeedbacksOrdered(
      String spaceId, String orderBy) async {
    try {
      QuerySnapshot allFeedbacksDocuments = await feedbacksCollection
          .where('space_id', isEqualTo: spaceId)
          .orderBy(orderBy, descending: true)
          .get();

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
      avatar: feedbackDocument['avatar'] ?? '',
    );
  }

  Future<String> getUserName() async {
    final userDocument = await getUserDocument();
    if (userDocument.exists) {
      final userData = userDocument.data() as Map<String, dynamic>;
      final name = userData['name'];

      return name.toString();
    }
    // Trate o caso em que o documento não contém o campo "name" ou não existe.
    throw Exception("Nome do usuário não encontrado");
  }

  Future<String> getUserAvatar() async {
    final userDocument = await getUserDocument();
    if (userDocument.exists) {
      final userData = userDocument.data() as Map<String, dynamic>;
      final avatar = userData['avatar_url'];

      return avatar.toString();
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

  @override
  Future<Either<RepositoryException, List<FeedbackModel>>> getMyFeedbacks(
      String userId) async {
    try {
      final allFeedbacksDocuments =
          await feedbacksCollection.where('user_id', isEqualTo: userId).get();

      List<FeedbackModel> feedbackModels =
          allFeedbacksDocuments.docs.map((feedbackDocument) {
        return mapFeedbackDocumentToModel(feedbackDocument);
      }).toList();
      return Success(feedbackModels);
    } catch (e) {
      log('Erro ao recuperar os meus feeedbacks do firestore: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar os meus feedbacks'));
    }
  }
}
