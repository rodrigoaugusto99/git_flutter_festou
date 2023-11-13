import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/new_feedback_widget.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/widgets/feedback_widget.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SpaceFeedbacksPage extends ConsumerStatefulWidget {
  final SpaceModel space;
  final int? x;

  const SpaceFeedbacksPage({
    super.key,
    required this.space,
    this.x,
  });

  @override
  ConsumerState<SpaceFeedbacksPage> createState() => _SpaceFeedbacksPageState();
}

class _SpaceFeedbacksPageState extends ConsumerState<SpaceFeedbacksPage> {
  @override
  Widget build(BuildContext context) {
    final spaceFeedbacks =
        ref.watch(spaceFeedbacksVmProvider(widget.space, 'date'));

    return spaceFeedbacks.when(
      data: (SpaceFeedbacksState data) {
        if (data.feedbacks.isEmpty) {
          return const Center(
            child: Text('Sem avaliações(ainda)'),
          );
        }
        log('Average Rating: ${widget.space.averageRating}');
        return NewFeedbackWidget(
          x: widget.x,
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
    );
  }
}
