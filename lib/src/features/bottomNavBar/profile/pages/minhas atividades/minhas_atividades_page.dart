import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/meus_feedbacks_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas%20reservas/minhas_reservas_page.dart';

class MinhasAtividadesPage extends StatefulWidget {
  final String userId;
  const MinhasAtividadesPage({
    super.key,
    required this.userId,
  });

  @override
  State<MinhasAtividadesPage> createState() => _MinhasAtividadesPageState();
}

class _MinhasAtividadesPageState extends State<MinhasAtividadesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: ListView(
        children: [
          MinhasReservasPage(
            userId: widget.userId,
          ),
          MeusFeedbacksPage(
            userId: widget.userId,
          ),
        ],
      ),
    );
  }
}
