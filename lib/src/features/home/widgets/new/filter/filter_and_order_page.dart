import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/filter/filter_and_order_state.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/filter/new_page_filtered.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/feedbacks_panel.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/filter/filter_and_order_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/services_panel.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/type_panel.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/weekdays_panel.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class FilterAndOrderPage extends ConsumerStatefulWidget {
  const FilterAndOrderPage({
    super.key,
  });

  @override
  ConsumerState<FilterAndOrderPage> createState() => _FilterAndOrderPageState();
}

class _FilterAndOrderPageState extends ConsumerState<FilterAndOrderPage> {
  @override
  Widget build(BuildContext context) {
    final filterAnOrderVm = ref.watch(filterAndOrderVmProvider.notifier);

    ref.listen(filterAndOrderVmProvider, (_, state) {
      switch (state) {
        case FilterAndOrderState(status: FilterAndOrderStateStatus.success):
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const NewPageFiltered()));
          Messages.showSuccess('Filtrado com sucesso!', context);
        case FilterAndOrderState(status: FilterAndOrderStateStatus.error):
          Messages.showError('Erro ao filtrar espaços', context);
      }
    });
    final y = MediaQuery.of(context).size.height;
    void showFilterModal(BuildContext context) {
      final selectedServices =
          ref.read(filterAndOrderVmProvider).selectedServices;
      final selectedTypes = ref.read(filterAndOrderVmProvider).selectedTypes;
      final availableDays = ref.read(filterAndOrderVmProvider).availableDays;
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
                  ElevatedButton(
                    onPressed: () => setState(() {
                      filterAnOrderVm.redefinir();
                    }),
                    child: const Text('Redefinir'),
                  ),
                  const Text(
                    'Filtrar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ServicesPanel(
                    text: 'SERVIÇOS do espaço',
                    onServicePressed: (value) {
                      //log('onServicePressed: $value');
                      filterAnOrderVm.addOrRemoveService(value);
                    },
                    selectedServices: selectedServices,
                  ),
                  TypePanel(
                    text: 'TIPO de espaço',
                    onTypePressed: (value) {
                      //log('onTypePressed: $value');
                      filterAnOrderVm.addOrRemoveType(value);
                    },
                    selectedTypes: selectedTypes,
                  ),
                  WeekDaysPanel(
                    text: 'dias disponiveis',
                    onDayPressed: (value) {
                      //log('onTypePressed: $value');
                      filterAnOrderVm.addOrRemoveAvailableDay(value);
                    },
                    availableDays: availableDays,
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
                        await filterAnOrderVm.filter();
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
