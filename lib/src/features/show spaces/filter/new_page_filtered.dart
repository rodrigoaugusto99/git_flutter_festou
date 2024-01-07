import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/my_sliver_list_filtered.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/filter_and_order_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/filter_and_order_vm.dart';

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
          const SliverToBoxAdapter(
            child: Text('SPACES FILTERED'),
          ),
          MySliverListFiltered(spaces: spaces),
        ],
      ),
    );
  }
}
