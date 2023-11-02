import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/feedbacks_panel.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/filter/filter_and_order_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/services_panel.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/type_panel.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/weekdays_panel.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class FilterAndOrderPage extends ConsumerWidget {
  const FilterAndOrderPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaceFilterVm = ref.watch(filterAndOrderVmProvider.notifier);
    final y = MediaQuery.of(context).size.height;
    void showFilterModal(BuildContext context) {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: y * 0.9,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filtrar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ServicesPanel(
                    text: 'SERVIÇOS do espaço',
                    onServicePressed: (value) {
                      //log('onServicePressed: $value');
                      spaceFilterVm.addOrRemoveService(value);
                    },
                  ),
                  TypePanel(
                    text: 'TIPO de espaço',
                    onTypePressed: (value) {
                      //log('onTypePressed: $value');
                      spaceFilterVm.addOrRemoveType(value);
                    },
                  ),
                  WeekDaysPanel(
                    text: 'dias disponiveis',
                    onDayPressed: (value) {
                      //log('onTypePressed: $value');
                      spaceFilterVm.addOrRemoveAvailableDay(value);
                    },
                  ),
                  FeedbacksPanel(
                    text: 'MÉDIA de avaliações',
                    onNotePressed: (String value) {
                      //log('onNotePressed: $value');
                      //spaceFilterVm.addOrRemoveNote(value);
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () async {
                        await spaceFilterVm.filter();
                      },
                      child: const Text('Aplicar filtros'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    final x = MediaQuery.of(context).size.width;
    return SliverAppBar(
      automaticallyImplyLeading: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.symmetric(horizontal: x * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => showFilterModal(context),
                child: const Text(
                  'filtrar',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              const Text(
                'ordenar',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      foregroundColor: Colors.black,
      backgroundColor: Colors.blueGrey,
      pinned: false,
    );
  }
}
