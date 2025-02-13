import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/reservas%20e%20avalia%C3%A7%C3%B5es/meus%20feedbacks/minhas_avaliacoes_widgets.dart';
import 'package:festou/src/models/avaliacoes_model.dart';
import 'package:festou/src/services/avaliacoes_service.dart';

class MinhasAvaliacoesPage extends StatelessWidget {
  final String userId;
  const MinhasAvaliacoesPage({super.key, required this.userId});

  Future<List<AvaliacoesModel>> _getFeedbacks() async {
    List<AvaliacoesModel> feedbacks = await AvaliacoesService()
        .getMyFeedbacks(FirebaseAuth.instance.currentUser!.uid);

    return feedbacks.where((feedback) => feedback.deletedAt == null).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AvaliacoesModel>>(
      future: _getFeedbacks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MinhasAvaliacoesWidget(initialFeedbacks: snapshot.data!);
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ExpansionTile(
            collapsedBackgroundColor: Colors.white,
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            leading: Image.asset(
              'lib/assets/images/icon_avaliacao.png',
              width: 30,
              height: 30,
            ),
            title: const Text(
              'Minhas avaliações',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            children: const [],
          ),
        );
      },
    );
  }
}
