import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/widget/patternedButton.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/pagamentos/new_card_view.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/pix_page.dart';
import 'package:git_flutter_festou/src/models/card_model.dart';
import 'package:git_flutter_festou/src/services/encryption_service.dart';

class Pagamentos extends StatefulWidget {
  const Pagamentos({super.key});

  @override
  State<Pagamentos> createState() => _PagamentosState();
}

class _PagamentosState extends State<Pagamentos>
    with SingleTickerProviderStateMixin {
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
      // Obter o documento do usuário pelo `userId`
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: userId)
          .get();

      // Garantir que os documentos retornados não estejam vazios
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first; // Primeiro usuário encontrado

        // Acessar a subcoleção `cards` dentro do usuário
        final cardsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id) // ID do usuário
            .collection('cards') // Subcoleção
            .get();

        // Mapear os documentos da subcoleção `cards` para `CardModel`
        return cardsSnapshot.docs.map((cardDoc) {
          final data = cardDoc.data();

          // Descriptografar os campos sensíveis
          return CardModel(
            id: cardDoc.id,
            name: data['name'],
            cardName: data['cardName'],
            number: encryptionService
                .decrypt(data['number']), // Descriptografar número
            validateDate: encryptionService
                .decrypt(data['validateDate']), // Descriptografar validade
            cvv: encryptionService.decrypt(data['cvv']), // Descriptografar CVV
          );
        }).toList();
      } else {
        // Caso nenhum usuário seja encontrado, retorne uma lista vazia
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
        .animate(_animationController); // 0 a 0.5 (180° de rotação)
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCards(); // Recarrega os cartões sempre que a tela for exibida
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pix',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              PatternedButton(
                widget: Image.asset(
                  'lib/assets/images/icon_pix.png',
                  width: 26,
                  height: 26,
                ),
                title: 'Pagar com Pix',
                textButton: '',
                buttonWithTextLink: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PixPage(),
                    ),
                  );
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
                          height: 55,
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
                                child: PatternedButton(
                                    textButton: '',
                                    buttonWithTextLink: false,
                                    title: card.cardName,
                                    widget: Image.asset(
                                      'lib/assets/images/image 4carotn.png',
                                      height: 26,
                                    ),
                                    onTap: () async {
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

                                      // Verifica o tipo do retorno
                                      if (result is String &&
                                          result == 'deleted') {
                                        setState(() {
                                          cards.removeWhere(
                                              (c) => c.id == card.id);
                                        });
                                      } else if (result is CardModel) {
                                        // Atualiza ou adiciona o cartão na lista local
                                        setState(() {
                                          final index = cards.indexWhere(
                                              (c) => c.id == result.id);
                                          if (index != -1) {
                                            cards[index] =
                                                result; // Atualiza o cartão existente
                                          } else {
                                            cards.add(
                                                result); // Adiciona o novo cartão
                                          }
                                        });
                                      }
                                    }),
                              );
                            }),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: PatternedButton(
                                textButton: '',
                                buttonWithTextLink: false,
                                title: 'Adicionar cartão de crédito',
                                widget: Image.asset(
                                    'lib/assets/images/image 4xxdfad.png'),
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
                                      cards.add(
                                          newCard); // Adiciona o novo cartão à lista local
                                    });
                                  }
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
