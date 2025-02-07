import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_feedback_widget_limited.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_vm.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SpaceFeedbacksPageLimited extends ConsumerStatefulWidget {
  final SpaceModel space;
  final int? x;

  const SpaceFeedbacksPageLimited({
    super.key,
    required this.space,
    this.x,
  });

  @override
  ConsumerState<SpaceFeedbacksPageLimited> createState() =>
      _SpaceFeedbacksPageLimitedState();
}

class _SpaceFeedbacksPageLimitedState
    extends ConsumerState<SpaceFeedbacksPageLimited> {
  @override
  Widget build(BuildContext context) {
    final spaceFeedbacks =
        ref.watch(spaceFeedbacksVmProvider(widget.space, 'date'));

    return spaceFeedbacks.when(
      data: (SpaceFeedbacksState data) {
        if (data.feedbacks.isEmpty) {
          return const Center(
            child: Text(
              'Sem avaliações(ainda)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return NewFeedbackWidgetLimited(
          x: widget.x,
          feedbacks: data.feedbacks,
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
    );
  }
}
