import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/feedbacks_widgets.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/meus_feedbacks_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/meus_feedbacks_vm.dart';
import 'package:git_flutter_festou/src/features/register/feedback/feedback_register_page.dart';

class MeusFeedbacksPage extends ConsumerStatefulWidget {
  final String userId;
  const MeusFeedbacksPage({super.key, required this.userId});

  @override
  ConsumerState<MeusFeedbacksPage> createState() => _MeusFeedbacksPageState();
}

class _MeusFeedbacksPageState extends ConsumerState<MeusFeedbacksPage> {
  @override
  Widget build(BuildContext context) {
    final meusFeedbacks = ref.watch(meusFeedbacksVmProvider(widget.userId));

    return meusFeedbacks.when(
      data: (MeusFeedbacksState data) {
        return FeedbacksWidget(
          data: data,
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return const Center(
          child: Text('Erro'),
        );
      },
      loading: () {
        return const Stack(children: [
          Center(child: Text('Inserir carregamento Personalizado papai')),
          Center(child: CircularProgressIndicator()),
        ]);
      },
    );
  }
}
