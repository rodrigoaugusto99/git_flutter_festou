import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/feedbacks_widgets.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/meus_feedbacks_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/meus_feedbacks_vm.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/models/feedback_model.dart';
import 'package:git_flutter_festou/src/services/feedback_service.dart';

class MeusFeedbacksPage extends StatefulWidget {
  final String userId;
  const MeusFeedbacksPage({super.key, required this.userId});

  @override
  State<MeusFeedbacksPage> createState() => _MeusFeedbacksPageState();
}

class _MeusFeedbacksPageState extends State<MeusFeedbacksPage> {
  List<FeedbackModel>? feedbacks;
  User? currUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getFeedbacks();
    super.initState();
  }

  getFeedbacks() async {
    feedbacks = await FeedbackService().getMyFeedbacks(currUser!.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return feedbacks != null
        ? FeedbacksWidget(
            feedbacks: feedbacks!,
          )
        : const Center(child: CircularProgressIndicator());
  }
}
