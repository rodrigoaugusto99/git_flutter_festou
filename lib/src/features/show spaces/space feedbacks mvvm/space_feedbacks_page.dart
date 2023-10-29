import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/widgets/feedback_widget.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SpaceFeedbacksPage extends ConsumerStatefulWidget {
  final SpaceModel space;
  const SpaceFeedbacksPage({
    super.key,
    required this.space,
  });

  @override
  ConsumerState<SpaceFeedbacksPage> createState() => _SpaceFeedbacksPageState();
}

class _SpaceFeedbacksPageState extends ConsumerState<SpaceFeedbacksPage> {
  @override
  Widget build(BuildContext context) {
    final spaceFeedbacks = ref.watch(spaceFeedbacksVmProvider(widget.space));

    return Scaffold(
        body: spaceFeedbacks.when(
      data: (SpaceFeedbacksState data) {
        if (data.feedbacks.isEmpty) {
          return const Center(
            child: Text('Nao tem comentarios'),
          );
        }
        return FeedbackWidget(
          data: data,
          spaces: spaceFeedbacks,
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return const Center(
          child: Text('Erro'),
        );
      },
      loading: () {
        return const Center(
          child: Text('Loading'),
        );
      },
    ));
  }
}
