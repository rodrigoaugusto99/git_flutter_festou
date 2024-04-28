import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/filter_and_order_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/filter_and_order_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/new_page_filtered.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/widgets/feedbacks_panel.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/services_panel.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/type_panel.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/weekdays_panel.dart';

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
            height: y * 0.8,
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
                  // TypePanel(
                  //   text: 'TIPO de espaço',
                  //   onTypePressed: (value) {
                  //     //log('onTypePressed: $value');
                  //     filterAnOrderVm.addOrRemoveType(value);
                  //   },
                  //   selectedTypes: selectedTypes,
                  // ),
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              //color: Colors.white.withOpacity(0.7),
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.notifications_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
      leading: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Container(
          decoration: BoxDecoration(
            //color: Colors.white.withOpacity(0.7),
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: const Text(
        'Espaços filtrados',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      pinned: false,
    );
  }
}
