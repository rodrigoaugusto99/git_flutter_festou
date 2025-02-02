import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/reservas%20e%20avalia%C3%A7%C3%B5es/meus%20feedbacks/minhas_avaliacoes_widgets.dart';
import 'package:git_flutter_festou/src/models/avaliacoes_model.dart';
import 'package:git_flutter_festou/src/services/avaliacoes_service.dart';

class MinhasAvaliacoesPage extends StatefulWidget {
  final String userId;
  const MinhasAvaliacoesPage({super.key, required this.userId});

  @override
  State<MinhasAvaliacoesPage> createState() => _MinhasAvaliacoesPageState();
}

class _MinhasAvaliacoesPageState extends State<MinhasAvaliacoesPage> {
  List<AvaliacoesModel>? feedbacks;
  User? currUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getFeedbacks();
    super.initState();
  }

  getFeedbacks() async {
    feedbacks = await AvaliacoesService().getMyFeedbacks(currUser!.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return feedbacks != null
        ? MinhasAvaliacoesWidget(
            feedbacks: feedbacks!,
          )
        : const Center(child: CircularProgressIndicator());
  }
}
