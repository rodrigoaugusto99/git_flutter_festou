import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/login_seguranca.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas_atividades_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/pagamentos/pagamentos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/mensagens/mensagens.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu/menu.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/notificacoes_page.dart';
import 'package:git_flutter_festou/src/features/widgets/notifications_counter.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class MyRowsConfig extends StatefulWidget {
  final UserModel userModel;
  const MyRowsConfig({super.key, required this.userModel});

  @override
  State<MyRowsConfig> createState() => _MyRowsConfigState();
}

class _MyRowsConfigState extends State<MyRowsConfig> {
  late NotificationCounter _notificationCounter;

  @override
  void initState() {
    super.initState();
    _notificationCounter = NotificationCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        myRow(
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
        myRow(
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
        myRow(
          text: 'Métodos de pagamento',
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
        myRow(
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
        myRow(
          text: 'Minhas notificações',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificacoesPage(),
            ),
          ),
          icon1: const Icon(Icons.notifications_outlined),
        ),
        const SizedBox(height: 16),
        StreamBuilder<int>(
          stream: _notificationCounter.notificationCount,
          builder: (context, snapshot) {
            int unreadCount = snapshot.data ?? 0;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                myRow(
                  text: 'Mensagens',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Mensagens(),
                    ),
                  ),
                  icon1: Image.asset('lib/assets/images/icon_messages.png'),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: -10,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 17,
                        minHeight: 17,
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 99 ? '99+' : '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
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
