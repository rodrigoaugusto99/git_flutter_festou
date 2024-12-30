import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/widget/buttonOption.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/pagamentos/new_card_view.dart';
import 'package:git_flutter_festou/src/models/card_model.dart';

class Pagamentos extends StatefulWidget {
  const Pagamentos({super.key});

  @override
  State<Pagamentos> createState() => _PagamentosState();
}

class _PagamentosState extends State<Pagamentos>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  List<bool> selectedRows = [false, false, false];
  late AnimationController _animationController;
  late Animation<double> _iconRotationAnimation;
  List<CardModel> cards = [];

  static Future<List<CardModel>> fetchFromFirestore() async {
    try {
      final collection = FirebaseFirestore.instance.collection('cards');
      final querySnapshot = await collection.get();
      return querySnapshot.docs.map((doc) {
        return CardModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch cards from Firestore: $e');
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
        .animate(_animationController); // 0 a 0.5 (180° de rotação)
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> getCards() async {
    cards = await fetchFromFirestore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Métodos de Pagamento',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Pix',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              ButtonOption(
                widget: Image.asset(
                  'lib/assets/images/Pix Imagepix.png',
                  width: 26,
                  height: 26,
                ),
                subtitle: 'Pagar com Pix',
                textButton: '',
                onTap: () {
                  setState(() {});
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Cartões',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isExpanded ? const Color(0xff4300B1) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
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
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Image.asset(
                                'lib/assets/images/image 4carotn.png',
                                height: 26,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Pagar com Cartao de Crédito',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isExpanded
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              RotationTransition(
                                turns: _iconRotationAnimation,
                                child: Icon(
                                  Icons.expand_more,
                                  color:
                                      isExpanded ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizeTransition(
                        sizeFactor: _animationController,
                        child: Column(
                          children: [
                            ...cards.map((card) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ButtonOption(
                                  textButton: '',
                                  subtitle:
                                      'Cartao ${card.number.substring(0, 4)}',
                                  widget: Image.asset(
                                    'lib/assets/images/image 4carotn.png',
                                    width: 26,
                                    height: 26,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context, card);
                                  },
                                ),
                              );
                            }),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ButtonOption(
                                textButton: '',
                                subtitle: 'Adicionar novo cartão de crédito',
                                widget: Image.asset(
                                    'lib/assets/images/image 4xxdfad.png'),
                                onTap: () async {
                                  final response = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewCardView(
                                        isNew: true,
                                      ),
                                    ),
                                  );
                                  if (response == null) return;
                                  Navigator.pop(context, response);
                                },
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
      ),
    );
  }
}
