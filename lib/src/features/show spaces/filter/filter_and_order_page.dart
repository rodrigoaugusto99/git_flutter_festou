import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/show%20spaces/filter/filter_and_order_state.dart';
import 'package:festou/src/features/show%20spaces/filter/filter_and_order_vm.dart';
import 'package:festou/src/features/show%20spaces/filter/new_page_filtered.dart';
import 'package:festou/src/features/space%20card/widgets/notificacoes_page.dart';

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
    ref.watch(filterAndOrderVmProvider.notifier);

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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificacoesPage(locador: false),
                ),
              ),
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
      pinned: true,
    );
  }
}
