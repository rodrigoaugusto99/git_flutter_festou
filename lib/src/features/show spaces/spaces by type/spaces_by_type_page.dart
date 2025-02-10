import 'dart:developer';

import 'package:Festou/src/models/space_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Festou/src/core/ui/helpers/messages.dart';
import 'package:Festou/src/features/register/space/widgets/services_panel.dart';
import 'package:Festou/src/features/register/space/widgets/type_panel.dart';
import 'package:Festou/src/features/register/space/widgets/weekdays_panel.dart';
import 'package:Festou/src/features/show%20spaces/filter/filter_and_order_state.dart';
import 'package:Festou/src/features/show%20spaces/filter/filter_and_order_vm.dart';
import 'package:Festou/src/features/show%20spaces/filter/new_page_filtered.dart';
import 'package:Festou/src/features/show%20spaces/filter/widgets/feedbacks_panel.dart';
import 'package:Festou/src/features/show%20spaces/spaces%20by%20type/spaces_by_type_vm.dart';
import 'package:Festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SpacesByTypePage extends ConsumerStatefulWidget {
  final List<String> type;
  const SpacesByTypePage({super.key, required this.type});

  @override
  ConsumerState<SpacesByTypePage> createState() => _SpacesByTypePageState();
}

class _SpacesByTypePageState extends ConsumerState<SpacesByTypePage> {
  List<String> searchHistory = [];
  SpacesByTypeVm spaceByTypeViewModel = SpacesByTypeVm();
  final PagingController<DocumentSnapshot?, SpaceModel> pagingController =
      PagingController(firstPageKey: null);
  static const int _pageSize = 3;

  @override
  void initState() {
    //spaceByTypeViewModel.init(widget.type);

    super.initState();

    // **Carregar os primeiros 3 espaços ao iniciar a tela**
    spaceByTypeViewModel.fetchInitialSpaces(widget.type).then((_) {
      pagingController.notifyListeners(); // 🚨 Força a UI a ser atualizada
    });

    pagingController.addPageRequestListener((pageKey) {
      log("🚀 Página solicitada: ${pageKey?.id ?? 'null'}");
      _fetchPage(pageKey);
    });

    spaceByTypeViewModel.addListener(_onTextChanged);
  }

  Future<void> _fetchPage(DocumentSnapshot? pageKey) async {
    log("🔄 Starting _fetchPage() with pageKey: ${pageKey?.id ?? 'null'}");

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulação de atraso

      await spaceByTypeViewModel
          .fetchSpaces(pageKey); // 🚨 Agora apenas chama a função

      log("✅ Fetch process completed.");
    } catch (error, stacktrace) {
      log("❌ Error in _fetchPage(): $error");
      log("🔍 Stacktrace: $stacktrace");
      pagingController.error = error;
    }
  }

  @override
  void dispose() {
    spaceByTypeViewModel.removeListener(_onTextChanged);
    spaceByTypeViewModel.dispose();
    pagingController.dispose();
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
        //Messages.showSuccess('Filtrado com sucesso!', context);
        case FilterAndOrderState(status: FilterAndOrderStateStatus.error):
          Messages.showError('Erro ao filtrar espaços', context);
      }
    });
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;

    void showFilterModal(BuildContext context) {
      if (!ref
          .read(filterAndOrderVmProvider)
          .selectedTypes
          .contains(widget.type[0])) {
        filterAnOrderVm.addOrRemoveType(widget.type[0]);
      }
      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return Container(
              height: y * 0.8,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        filterAnOrderVm.redefinir();
                        setModalState(() {}); // Atualiza o modal
                      },
                      child: const Text('Redefinir'),
                    ),
                    const Text(
                      'Filtrar',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ServicesPanel(
                      text: 'SERVIÇOS do espaço',
                      onServicePressed: (value) {
                        //log('onServicePressed: $value');
                        filterAnOrderVm.addOrRemoveService(value);
                      },
                      selectedServices:
                          ref.read(filterAndOrderVmProvider).selectedServices,
                    ),
                    TypePanel(
                      text: 'TIPO de espaço',
                      onTypePressed: (value) {
                        //log('onTypePressed: $value');
                        filterAnOrderVm.addOrRemoveType(value);
                      },
                      selectedTypes:
                          ref.read(filterAndOrderVmProvider).selectedTypes,
                    ),
                    WeekDaysPanel(
                      text: 'dias disponiveis',
                      onDayPressed: (value) {
                        //log('onTypePressed: $value');
                        filterAnOrderVm.addOrRemoveAvailableDay(value);
                      },
                      availableDays:
                          ref.read(filterAndOrderVmProvider).availableDays,
                    ),
                    FeedbacksPanel(
                      selectedNotes:
                          ref.read(filterAndOrderVmProvider).selectedNotes,
                      text: 'MÉDIA de avaliações',
                      onNotePressed: (String value) {
                        log('onNotePressed: $value');
                        filterAnOrderVm.addOrRemoveNote(value);
                        setModalState(() {});
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
          });
        },
      );
    }

    Map<String, String> cds = {
      "Debutante": "lib/assets/images/background_debutante.png",
      "Kids": "lib/assets/images/background_kids.png",
      "Casamento": "lib/assets/images/background_casamento.png",
      "Reuniao": "lib/assets/images/background_reuniao.png",
      "Outros": "lib/assets/images/background_outros.png",
      "Religioso": "lib/assets/images/background_religioso.png",
      "Cha": "lib/assets/images/background_cha.png",
    };

    return SafeArea(
      top: false,
      child: AnimatedBuilder(
          animation: spaceByTypeViewModel,
          builder: (context, child) {
            return Scaffold(
              //backgroundColor: Colors.white,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                // backgroundColor: Colors.white,
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
                title: Text(
                  widget.type[0],
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                elevation: 0,
              ),
              body: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(cds[widget.type[0]]!),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
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
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                //color: Colors.white.withOpacity(0.7),
                                color: const Color(0xff9747FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                  'lib/assets/images/icon_filtro.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if ((spaceByTypeViewModel.getSpaces != null &&
                        spaceByTypeViewModel.showSpacesByType &&
                        spaceByTypeViewModel.getSpaces!.isEmpty))
                      const Text('Não foram encontrado espaços'),
                    if ((spaceByTypeViewModel.getFiltered.isEmpty &&
                        spaceByTypeViewModel.showFiltered &&
                        spaceByTypeViewModel.getFiltered.isEmpty))
                      const Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text('Não foram encontrado espaços')),
                      ),
                    if (spaceByTypeViewModel.getSpaces != null &&
                        spaceByTypeViewModel.showSpacesByType) ...[
                      Expanded(
                        child: PagedListView<DocumentSnapshot?, SpaceModel>(
                          pagingController: spaceByTypeViewModel
                              .pagingController, // 🚨 Certifique-se de que este é o mesmo controller atualizado
                          builderDelegate:
                              PagedChildBuilderDelegate<SpaceModel>(
                            itemBuilder: (context, item, index) {
                              return NewSpaceCard(
                                hasHeart: true,
                                space: item,
                                isReview: false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    if (spaceByTypeViewModel.getFiltered.isNotEmpty &&
                        spaceByTypeViewModel.showFiltered)
                      Expanded(
                        child: PagedListView<DocumentSnapshot?, SpaceModel>(
                          pagingController:
                              spaceByTypeViewModel.pagingController,
                          builderDelegate:
                              PagedChildBuilderDelegate<SpaceModel>(
                            itemBuilder: (context, item, index) {
                              log("Building item: ${item.spaceId}"); // 🛑 Verificação de exibição
                              return NewSpaceCard(
                                hasHeart: true,
                                space: item,
                                isReview: false,
                              );
                            },
                          ),
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
