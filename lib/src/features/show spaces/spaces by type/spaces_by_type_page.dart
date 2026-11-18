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
  static const _bg = Color(0xFFFAF7FC);
  static const _ink = Color(0xFF1C1426);
  static const _muted = Color(0xFF8A8096);
  static const _accent = Color(0xFF7C3AED);

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

    const bgImages = <String, String>{
      'Debutante': 'lib/assets/images/background_debutante.png',
      'Kids': 'lib/assets/images/background_kids.png',
      'Casamento': 'lib/assets/images/background_casamento.png',
      'Reunião': 'lib/assets/images/background_reuniao.png',
      'Outros': 'lib/assets/images/background_outros.png',
      'Religioso': 'lib/assets/images/background_religioso.png',
      'Chá': 'lib/assets/images/background_cha.png',
    };

    final typeName = widget.type[0];
    final bgAsset = bgImages[typeName];

    return AnimatedBuilder(
      animation: spaceByTypeViewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _bg,
          resizeToAvoidBottomInset: true,
          body: Container(
            decoration: BoxDecoration(
              color: _bg,
              image: bgAsset == null
                  ? null
                  : DecorationImage(
                      image: AssetImage(bgAsset),
                      fit: BoxFit.cover,
                      opacity: 0.16,
                    ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(typeName),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      children: [
                        Expanded(child: _buildSearchBox()),
                        const SizedBox(width: 10),
                        _buildFilterButton(() => showFilterModal(context)),
                      ],
                    ),
                  ),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(String typeName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.of(context).pop(),
              child: Ink(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE8DFF8)),
                  boxShadow: [
                    BoxShadow(
                      color: _accent.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: _ink,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeName,
                  style: const TextStyle(
                    fontFamily: 'RedHatDisplay',
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
                    letterSpacing: -0.5,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Espaços disponíveis nesta categoria',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificacoesPage(locador: false),
                  ),
                );
              },
              child: Ink(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF7F1FF),
                      Color(0xFFEFE4FF),
                    ],
                  ),
                  border: Border.all(color: const Color(0xFFE0D0FF)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6100FF).withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_rounded,
                      color: Color(0xFF6100FF),
                      size: 24,
                    ),
                    Positioned(
                      top: 11,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4D6D),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF9747FF), Color(0xFF6100FF)],
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.28),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'lib/assets/images/icon_filtro.png',
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    final hasText = spaceByTypeViewModel.controller.text.isNotEmpty;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8DFF8)),
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: _accent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: spaceByTypeViewModel.controller,
              onChanged: (value) {
                spaceByTypeViewModel.onChangedSearch(value, widget.type);
              },
              onSubmitted: (_) => setState(() {}),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _ink,
              ),
              cursorColor: _accent,
              decoration: const InputDecoration(
                hintText: 'Buscar no Festou',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: _muted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (hasText)
            InkWell(
              onTap: () => spaceByTypeViewModel.clear(),
              borderRadius: BorderRadius.circular(99),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EBFF),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: _accent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.96),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE8DFF8)),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 52, color: _muted),
              SizedBox(height: 14),
              Text(
                'Nenhum espaço encontrado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'RedHatDisplay',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: _ink,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tente outro termo ou ajuste os filtros para continuar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.45,
                  color: _muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final vm = spaceByTypeViewModel;

    if (vm.isLoading) {
      return const Center(child: CustomLoadingIndicator());
    }

    final emptyByType = vm.getSpaces != null &&
        vm.showSpacesByType &&
        vm.getSpaces!.isEmpty;
    final emptyFiltered = vm.getFiltered.isEmpty && vm.showFiltered;

    if (emptyByType || emptyFiltered) {
      return _buildEmptyState();
    }

    if (vm.showFiltered) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        itemCount: vm.getFiltered.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: NewSpaceCard(
              hasHeart: true,
              space: vm.getFiltered[index],
              isReview: false,
            ),
          );
        },
      );
    }

    return PagedListView<DocumentSnapshot?, SpaceModel>(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      pagingController: vm.pagingController,
      builderDelegate: PagedChildBuilderDelegate<SpaceModel>(
        itemBuilder: (context, item, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: NewSpaceCard(
              hasHeart: true,
              space: item,
              isReview: false,
            ),
          );
        },
        newPageProgressIndicatorBuilder: (_) => const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: CustomLoadingIndicator(),
          ),
        ),
        firstPageProgressIndicatorBuilder: (_) =>
            const Center(child: CustomLoadingIndicator()),
        noItemsFoundIndicatorBuilder: (_) => _buildEmptyState(),
      ),
    );
  }
}
