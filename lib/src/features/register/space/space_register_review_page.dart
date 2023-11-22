import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/home_page.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_state.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_vm.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class SpaceRegisterReviewPage extends ConsumerStatefulWidget {
  final SpaceWithImages space;
  const SpaceRegisterReviewPage({super.key, required this.space});

  @override
  ConsumerState<SpaceRegisterReviewPage> createState() =>
      _SpaceRegisterReviewPageState();
}

class _SpaceRegisterReviewPageState
    extends ConsumerState<SpaceRegisterReviewPage> {
  @override
  Widget build(BuildContext context) {
    final spaceRegister = ref.watch(spaceRegisterVmProvider.notifier);

    ref.listen(spaceRegisterVmProvider, (_, state) {
      switch (state) {
        case SpaceRegisterState(status: SpaceRegisterStateStatus.initial):
          break;
        case SpaceRegisterState(status: SpaceRegisterStateStatus.success):
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
          Messages.showSuccess('boaaaa', context);
        case SpaceRegisterState(
            status: SpaceRegisterStateStatus.error,
            :final errorMessage?
          ):
          Messages.showError(errorMessage, context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: [
          const Text('Seu espaço ficará assim:'),
          NewSpaceCard(
            space: widget.space,
            isReview: true,
          ),
          ElevatedButton(
            onPressed: () => spaceRegister.register(
              widget.space.space.titulo,
              widget.space.space.cep,
              widget.space.space.logradouro,
              widget.space.space.numero,
              widget.space.space.bairro,
              widget.space.space.cidade,
              widget.space.space.descricao,
              widget.space.space.city,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
