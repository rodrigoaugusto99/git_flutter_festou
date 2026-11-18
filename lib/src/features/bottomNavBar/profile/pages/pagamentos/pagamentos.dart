import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/widget/patternedButton.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/pagamentos/new_card_view.dart';
import 'package:festou/src/features/space%20card/widgets/pix_page.dart';
import 'package:festou/src/models/card_model.dart';
import 'package:festou/src/services/encryption_service.dart';

class Pagamentos extends StatefulWidget {
  final bool isReservationFlow;
  const Pagamentos({
    super.key,
    this.isReservationFlow = false,
  });

  @override
  State<Pagamentos> createState() => _PagamentosState();
}

class _PagamentosState extends State<Pagamentos>
    with SingleTickerProviderStateMixin {
  static const _bg = Color(0xFFFAF7FC);
  static const _ink = Color(0xFF1C1426);
  static const _muted = Color(0xFF8A8096);
  static const _accent = Color(0xFF7C3AED);

  final encryptionService =
      EncryptionService("criptfestouaplic", "2199478465899478");
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool isExpanded = false;
  List<bool> selectedRows = [false, false, false];
  late AnimationController _animationController;
  late Animation<double> _iconRotationAnimation;
  List<CardModel> cards = [];

  Future<List<CardModel>> fetchFromFirestore() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;

        final cardsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('cards')
            .get();

        return cardsSnapshot.docs.map((cardDoc) {
          final data = cardDoc.data();

          return CardModel(
            id: cardDoc.id,
            name: data['name'],
            cardName: data['cardName'],
            number: encryptionService.decrypt(data['number']),
            validateDate: encryptionService.decrypt(data['validateDate']),
            cvv: encryptionService.decrypt(data['cvv']),
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Erro ao buscar os dados: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getCards();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _iconRotationAnimation = Tween<double>(begin: 0, end: 0.5)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCards();
  }

  Future<void> getCards() async {
    cards = await fetchFromFirestore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Pix'),
                    const SizedBox(height: 8),
                    PatternedButton(
                      widget: Image.asset(
                        'lib/assets/images/logo_pix.png',
                        width: 22,
                        height: 22,
                      ),
                      title: 'Pagar com Pix',
                      textButton: '',
                      buttonWithTextLink: false,
                      onTap: () {
                        if (widget.isReservationFlow) {
                          Navigator.pop(context, true);
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PixPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    _sectionTitle('Cartões'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE8DFF8)),
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withOpacity(0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                  if (isExpanded) {
                                    _animationController.forward();
                                  } else {
                                    _animationController.reverse();
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 58,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: isExpanded
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF9747FF),
                                            Color(0xFF6100FF),
                                          ],
                                        )
                                      : null,
                                  color: isExpanded ? null : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isExpanded
                                            ? Colors.white.withOpacity(0.18)
                                            : const Color(0xFFF7F1FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'lib/assets/images/icon_card_color.png',
                                        height: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Cartão de crédito',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: isExpanded
                                              ? Colors.white
                                              : _ink,
                                        ),
                                      ),
                                    ),
                                    RotationTransition(
                                      turns: _iconRotationAnimation,
                                      child: Icon(
                                        Icons.expand_more_rounded,
                                        color: isExpanded
                                            ? Colors.white
                                            : const Color(0xFFB5A9C5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizeTransition(
                            sizeFactor: _animationController,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Column(
                                children: [
                                  ...cards.map((card) {
                                    return PatternedButton(
                                      textButton: '',
                                      buttonWithTextLink: false,
                                      title: card.cardName,
                                      widget: Image.asset(
                                        'lib/assets/images/icon_card_color.png',
                                        height: 22,
                                      ),
                                      onTap: () async {
                                        if (widget.isReservationFlow) {
                                          Navigator.pop(context, card);
                                          return;
                                        }
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NewCardView(
                                              id: card.id,
                                              name: card.name,
                                              cardName: card.cardName,
                                              number: card.number,
                                              validateDate: card.validateDate,
                                              cvv: card.cvv,
                                            ),
                                          ),
                                        );

                                        if (result is String &&
                                            result == 'deleted') {
                                          setState(() {
                                            cards.removeWhere(
                                                (c) => c.id == card.id);
                                          });
                                        } else if (result is CardModel) {
                                          setState(() {
                                            final index = cards.indexWhere(
                                                (c) => c.id == result.id);
                                            if (index != -1) {
                                              cards[index] = result;
                                            } else {
                                              cards.add(result);
                                            }
                                          });
                                        }
                                      },
                                    );
                                  }),
                                  PatternedButton(
                                    textButton: '',
                                    buttonWithTextLink: false,
                                    title: 'Adicionar cartão de crédito',
                                    widget: Image.asset(
                                      'lib/assets/images/icon_add_card.png',
                                      height: 22,
                                    ),
                                    onTap: () async {
                                      final CardModel? newCard =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NewCardView(),
                                        ),
                                      );

                                      if (newCard != null) {
                                        setState(() {
                                          cards.add(newCard);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Métodos de pagamento',
                  style: TextStyle(
                    fontFamily: 'RedHatDisplay',
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.4,
                    color: _ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Gerencie Pix e cartões salvos',
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
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'RedHatDisplay',
        fontWeight: FontWeight.w800,
        fontSize: 16,
        letterSpacing: -0.2,
        color: _ink,
      ),
    );
  }
}
