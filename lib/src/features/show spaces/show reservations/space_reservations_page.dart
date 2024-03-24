import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/show%20reservations/space_reservations_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/show%20reservations/space_reservations_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/show%20reservations/widgets/show_reservations.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SpaceReservationsPage extends ConsumerStatefulWidget {
  final SpaceModel space;
  const SpaceReservationsPage({
    super.key,
    required this.space,
  });

  @override
  ConsumerState<SpaceReservationsPage> createState() =>
      _SpaceReservationsPageState();
}

class _SpaceReservationsPageState extends ConsumerState<SpaceReservationsPage> {
  @override
  Widget build(BuildContext context) {
    final spaceReservations =
        ref.watch(spaceReservationsVmProvider(widget.space));

    return spaceReservations.when(
      data: (SpaceReservationsState data) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: ShowReservations(
            data: data,
            reservas: spaceReservations,
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return const Stack(children: [
          Center(child: Icon(Icons.error)),
        ]);
      },
      loading: () {
        return const Stack(children: [
          Center(child: CustomLoadingIndicator()),
        ]);
      },
    );
  }
}
