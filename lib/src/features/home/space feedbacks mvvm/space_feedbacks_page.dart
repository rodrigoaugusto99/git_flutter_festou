import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:git_flutter_festou/src/features/home/space%20feedbacks%20mvvm/space_feedbacks_vm.dart';
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

    List<Icon> buildStarIcons(int rating) {
      return List.generate(
        rating,
        (index) => const Icon(
          Icons.star,
          color: Colors.yellow,
          size: 24.0,
        ),
      );
    }

    return Scaffold(
        body: spaceFeedbacks.when(
      data: (SpaceFeedbacksState data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.feedbacks.map((feedback) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Usuário X',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        '01/01/2023',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Avaliação:'),
                      const SizedBox(width: 8.0),
                      ...buildStarIcons(feedback.rating),
                    ],
                  ),
                  Text(
                    'Avaliação: ${feedback.rating}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text('Comentário:'),
                  Text(
                    feedback.content.toString(),
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
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
