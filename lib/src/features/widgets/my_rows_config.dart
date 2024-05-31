import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/login_seguranca.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas_atividades_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/pagamentos/pagamentos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/mensagens/mensagens.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu/menu.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class MyRowsConfig extends StatefulWidget {
  final UserModel userModel;
  const MyRowsConfig({super.key, required this.userModel});

  @override
  State<MyRowsConfig> createState() => _MyRowsConfigState();
}

class _MyRowsConfigState extends State<MyRowsConfig> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyRow(
          text: 'Informações pessoais',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InformacoesPessoais(userModel: widget.userModel),
            ),
          ),
          icon1: Image.asset(
            'lib/assets/images/Icon Personinformacoespessoais.png',
            width: 20,
          ),
        ),
        const SizedBox(height: 16),
        MyRow(
          text: 'Login e Segurança',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginSeguranca(),
            ),
          ),
          icon1: Image.asset(
              'lib/assets/images/Icon Segurançalogineseguranca.png'),
        ),
        const SizedBox(height: 16),
        MyRow(
          text: 'Métodos de Pagamento',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Pagamentos(),
            ),
          ),
          icon1: Image.asset(
            'lib/assets/images/icon_pagamentos.png',
          ),
        ),
        const SizedBox(height: 16),
        MyRow(
          text: 'Minhas atividades / Histórico',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MinhasAtividadesPage(userId: widget.userModel.id),
            ),
          ),
          icon1: Image.asset(
            'lib/assets/images/Icon Históricominhnasatividades.png',
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<QuerySnapshot>>(
          stream: FirebaseFirestore.instance
              .collection('chat_rooms')
              .where('chatRoomIDs',
                  arrayContains: FirebaseAuth.instance.currentUser!.uid)
              .snapshots()
              .switchMap((chatRoomsSnapshot) {
            if (chatRoomsSnapshot.docs.isEmpty) {
              return Stream.value([]);
            }

            List<Stream<QuerySnapshot>> messageStreams = chatRoomsSnapshot.docs
                .map((doc) => doc.reference
                    .collection('messages')
                    .where('receiverID',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .where('isSeen', isEqualTo: false)
                    .snapshots())
                .toList();

            return Rx.combineLatest(
                messageStreams, (List<QuerySnapshot> list) => list);
          }),
          builder: (context, snapshot) {
            bool hasUnreadMessages = snapshot.hasData &&
                snapshot.data!
                    .any((querySnapshot) => querySnapshot.docs.isNotEmpty);

            return MyRow(
              text: 'Mensagens',
              hasUnreadMessages: hasUnreadMessages,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Mensagens(),
                ),
              ),
              icon1: Image.asset(
                'lib/assets/images/icon_messages.png',
              ),
            );
          },
        ),
      ],
    );
  }

  String getChatRoomId(String receiverId, String senderId) {
    List<String> ids = [receiverId, senderId];
    ids.sort();
    return ids.join('_');
  }
}
