import 'dart:developer';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/features/space%20card/widgets/notificacoes_page.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/register/space/widgets/services_panel.dart';
import 'package:festou/src/features/register/space/widgets/type_panel.dart';
import 'package:festou/src/features/register/space/widgets/weekdays_panel.dart';
import 'package:festou/src/features/show%20spaces/filter/filter_and_order_state.dart';
import 'package:festou/src/features/show%20spaces/filter/filter_and_order_vm.dart';
import 'package:festou/src/features/show%20spaces/filter/new_page_filtered.dart';
import 'package:festou/src/features/show%20spaces/filter/widgets/feedbacks_panel.dart';
import 'package:festou/src/features/show%20spaces/spaces%20by%20type/spaces_by_type_vm.dart';
import 'package:festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SpacesByTypePage extends ConsumerStatefulWidget {
  final List<String> type;
  const SpacesByTypePage({super.key, required this.type});

  @override
  ConsumerState<SpacesByTypePage> createState() => _SpacesByTypePageState();
}

class _SpacesByTypePageState extends ConsumerState<SpacesByTypePage> {
  List<String> searchHistory = [];
  late SpacesByTypeVm spaceByTypeViewModel;
  final PagingController<DocumentSnapshot?, SpaceModel> pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();

    spaceByTypeViewModel = SpacesByTypeVm(widget.type);

    // Adiciona um listener para atualizar a UI sempre que showFiltered mudar
    spaceByTypeViewModel.addListener(() {
      if (mounted) {
        setState(() {}); // 🔥 Atualiza a UI automaticamente
      }
    });

    pagingController.addPageRequestListener((pageKey) {
      log("🚀 Página solicitada: ${pageKey?.id ?? 'null'}");
      _fetchPage(pageKey, widget.type);
    });

    spaceByTypeViewModel.addListener(_onTextChanged);
  }

  Future<void> _fetchPage(DocumentSnapshot? pageKey, List<String> types) async {
    log("🔄 Chamando _fetchPage() com tipo: $types");

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulação de atraso

      await spaceByTypeViewModel.fetchSpaces(
          pageKey, types); // 🔥 Agora passa o tipo

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
              height: y * 0.82,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Row(
                        children: [
                          const Text(
                            'Filtrar:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: x * 0.15),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    filterAnOrderVm.redefinir();
                                    setModalState(() {}); // Atualiza o modal
                                  },
                                  child: const Text('Limpar'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    await filterAnOrderVm.filter();
                                  },
                                  child: const Text('Aplicar'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: y * 0.01),
                    ServicesPanel(
                      text: 'Serviços oferecidos:',
                      onServicePressed: (value) {
                        //log('onServicePressed: $value');
                        filterAnOrderVm.addOrRemoveService(value);
                      },
                      selectedServices:
                          ref.read(filterAndOrderVmProvider).selectedServices,
                    ),
                    TypePanel(
                      text: 'Categorias do espaço:',
                      onTypePressed: (value) {
                        //log('onTypePressed: $value');
                        filterAnOrderVm.addOrRemoveType(value);
                      },
                      selectedTypes:
                          ref.read(filterAndOrderVmProvider).selectedTypes,
                    ),
                    WeekDaysPanel(
                      text: 'Dias disponíveis:',
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
                      text: 'Média das avaliações:',
                      onNotePressed: (String value) {
                        log('onNotePressed: $value');
                        filterAnOrderVm.addOrRemoveNote(value);
                        setModalState(() {});
                      },
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
      "Reunião": "lib/assets/images/background_reuniao.png",
      "Outros": "lib/assets/images/background_outros.png",
      "Religioso": "lib/assets/images/background_religioso.png",
      "Chá": "lib/assets/images/background_cha.png",
    };

    return SafeArea(
      top: false,
      child: AnimatedBuilder(
          animation: spaceByTypeViewModel,
          builder: (context, child) {
            return Scaffold(
              // backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffFFFFFF),
                        Color.fromARGB(209, 255, 255, 255),
                        Color.fromARGB(178, 255, 255, 255),
                        Color.fromARGB(0, 255, 255, 255),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificacoesPage(locador: false),
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
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
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
                ),
              ),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    cds[widget.type[0]]!,
                    fit: BoxFit.cover,
                  ),
                  Column(
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
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff9747FF),
                                      Color(0xff44300b1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Image.asset(
                                    'lib/assets/images/icon_filtro.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if ((!spaceByTypeViewModel.isLoading &&
                          spaceByTypeViewModel.getSpaces != null &&
                          spaceByTypeViewModel.showSpacesByType &&
                          spaceByTypeViewModel.getSpaces!.isEmpty))
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 41, right: 41, top: 281.4),
                            child: Container(
                              padding: const EdgeInsets.all(
                                  16), // Espaçamento interno
                              decoration: BoxDecoration(
                                color: Colors.white, // Fundo branco
                                borderRadius: BorderRadius.circular(
                                    12), // Bordas arredondadas
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.1), // Sombra leve
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset:
                                        const Offset(0, 3), // Direção da sombra
                                  ),
                                ],
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off,
                                      size: 60, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text(
                                    "Nenhum espaço encontrado",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Tente alterar os filtros ou buscar por outro termo",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (!spaceByTypeViewModel.isLoading &&
                          spaceByTypeViewModel.getFiltered.isEmpty &&
                          spaceByTypeViewModel.showFiltered)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 41, right: 41, top: 281.4),
                            child: Container(
                              padding: const EdgeInsets.all(
                                  16), // Espaçamento interno
                              decoration: BoxDecoration(
                                color: Colors.white, // Fundo branco
                                borderRadius: BorderRadius.circular(
                                    12), // Bordas arredondadas
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.1), // Sombra leve
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset:
                                        const Offset(0, 3), // Direção da sombra
                                  ),
                                ],
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off,
                                      size: 60, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text(
                                    "Nenhum espaço encontrado",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Tente alterar os filtros ou buscar por outro termo",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: spaceByTypeViewModel.isLoading
                            ? const Center(child: CustomLoadingIndicator())
                            : spaceByTypeViewModel.showFiltered
                                ? ListView.builder(
                                    padding: const EdgeInsets.only(top: 20),
                                    itemCount:
                                        spaceByTypeViewModel.getFiltered.length,
                                    itemBuilder: (context, index) {
                                      final space = spaceByTypeViewModel
                                          .getFiltered[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: NewSpaceCard(
                                          hasHeart: true,
                                          space: space,
                                          isReview: false,
                                        ),
                                      );
                                    },
                                  )
                                : PagedListView<DocumentSnapshot?, SpaceModel>(
                                    padding: const EdgeInsets.only(top: 0),
                                    pagingController:
                                        spaceByTypeViewModel.pagingController,
                                    builderDelegate:
                                        PagedChildBuilderDelegate<SpaceModel>(
                                      itemBuilder: (context, item, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: NewSpaceCard(
                                            hasHeart: true,
                                            space: item,
                                            isReview: false,
                                          ),
                                        );
                                      },
                                      newPageProgressIndicatorBuilder:
                                          (context) => const Center(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 20.0),
                                          child: CustomLoadingIndicator(),
                                        ),
                                      ),
                                      firstPageProgressIndicatorBuilder:
                                          (context) => const Center(
                                        child: CustomLoadingIndicator(),
                                      ),
                                      noItemsFoundIndicatorBuilder: (context) =>
                                          Center(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8, // 80% da largura da tela
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.search_off,
                                                  size: 60, color: Colors.grey),
                                              SizedBox(height: 10),
                                              Text(
                                                "Nenhum espaço encontrado",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Tente alterar os filtros ou buscar por outro termo",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ],
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
          padding:
              EdgeInsets.symmetric(horizontal: x * 0.02, vertical: y * 0.007),
          decoration: BoxDecoration(
              color: const Color(0xffF0F0F0),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.search, color: Colors.purple[300]),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Stack(
                      children: [
                        spaceByTypeViewModel.controller.text.isEmpty
                            ? RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.blueGrey[500]),
                                  children: const <TextSpan>[
                                    TextSpan(text: 'Buscar no '),
                                    TextSpan(
                                        text: 'Festou',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
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
                                      spaceByTypeViewModel.onChangedSearch(
                                          value, widget.type);
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
