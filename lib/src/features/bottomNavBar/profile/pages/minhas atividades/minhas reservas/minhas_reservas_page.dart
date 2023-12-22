import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas%20reservas/minhas_reservas_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas%20reservas/minhas_reservas_vm.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas%20reservas/reservas_widget.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

class MinhasReservasPage extends ConsumerStatefulWidget {
  final String userId;
  const MinhasReservasPage({super.key, required this.userId});

  @override
  ConsumerState<MinhasReservasPage> createState() => _MinhasReservasPageState();
}

class _MinhasReservasPageState extends ConsumerState<MinhasReservasPage> {
  @override
  Widget build(BuildContext context) {
    final minhasReservas = ref.watch(minhasReservasVmProvider(widget.userId));

    return minhasReservas.when(
      data: (MinhasReservasState data) {
        return ReservasWidget(
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
