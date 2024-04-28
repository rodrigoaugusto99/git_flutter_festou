import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/services_panel.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/weekdays_panel.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/filter_and_order_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/filter_and_order_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/new_page_filtered.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/widgets/feedbacks_panel.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20by%20type/spaces_by_type_vm.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';

class SpacesByTypePage extends ConsumerStatefulWidget {
  final List<String> type;
  const SpacesByTypePage({super.key, required this.type});

  @override
  ConsumerState<SpacesByTypePage> createState() => _SpacesByTypePageState();
}

class _SpacesByTypePageState extends ConsumerState<SpacesByTypePage> {
  List<String> searchHistory = [];
  SpacesByTypeVm spaceByTypeViewModel = SpacesByTypeVm();
  @override
  void initState() {
    spaceByTypeViewModel.init(widget.type);

    spaceByTypeViewModel.addListener(_onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    spaceByTypeViewModel.removeListener(_onTextChanged);
    spaceByTypeViewModel.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

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
    final x = MediaQuery.of(context).size.width;
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

    return SafeArea(
      child: AnimatedBuilder(
          animation: spaceByTypeViewModel,
          builder: (context, child) {
            return Scaffold(
              appBar: AppBar(
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
                            offset: const Offset(
                                0, 2), // changes position of shadow
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
                          offset:
                              const Offset(0, 2), // changes position of shadow
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
                  'Espaços por tipo',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildSearchBox(x, y),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: () => showFilterModal(context),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                //color: Colors.white.withOpacity(0.7),
                                color: const Color(0xff9747FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                  'lib/assets/images/Sliderfitl.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (spaceByTypeViewModel.getSpaces() != null &&
                        spaceByTypeViewModel.showSpacesByType)
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: spaceByTypeViewModel.getSpaces()!.length,
                          itemBuilder: (context, index) {
                            return NewSpaceCard(
                              hasHeart: true,
                              space: spaceByTypeViewModel.getSpaces()![index],
                              isReview: false,
                            );
                          },
                        ),
                      ),
                    if (spaceByTypeViewModel.getFiltered() != null &&
                        spaceByTypeViewModel.showFiltered)
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: spaceByTypeViewModel.getFiltered()!.length,
                          itemBuilder: (context, index) {
                            return NewSpaceCard(
                              hasHeart: true,
                              space: spaceByTypeViewModel.getFiltered()![index],
                              isReview: false,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildSearchBox(double x, double y) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: const Color(0xffF0F0F0),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.search, color: Color(0xff9747FF)),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Stack(
                      children: [
                        spaceByTypeViewModel.controller.text.isEmpty
                            ? const Text(
                                'Buscar',
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              )
                            : Container(
                                height: 0,
                              ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      spaceByTypeViewModel
                                          .onChangedSearch(value);
                                    },
                                    controller: spaceByTypeViewModel.controller,
                                    onSubmitted: (value) {
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Buscar',
                                      hintStyle:
                                          TextStyle(color: Colors.transparent),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                    ),
                                    style: TextStyle(
                                        color: Colors.blueGrey[900],
                                        fontSize: 12),
                                    cursorColor: Colors.blueGrey[900],
                                  ),
                                ),
                                Visibility(
                                  visible: spaceByTypeViewModel
                                      .controller.text.isNotEmpty,
                                  child: InkWell(
                                    onTap: () {
                                      spaceByTypeViewModel.clear();
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.blueGrey[900],
                                      size: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
