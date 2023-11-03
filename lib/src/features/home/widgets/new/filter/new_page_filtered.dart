import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/filter/filter_and_order_page.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/filter/filter_and_order_state.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/filter/filter_and_order_vm.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/my_sliver_list_filtered.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/my_sliver_to_box_adapter.dart';

class NewPageFiltered extends ConsumerWidget {
  const NewPageFiltered({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterAndOrder = ref.watch(filterAndOrderVmProvider);
    final spaces = filterAndOrder.filteredSpaces;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //AppBar com botao p/ filtrar
          const FilterAndOrderPage(),
          const MySliverToBoxAdapter(
            text: 'SPACES FILTEREDDDDDDDDDD',
          ),
          MySliverListFiltered(spaces: spaces),
        ],
      ),
    );
  }
}
