import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/pagamentos/new_card_view.dart';
import 'package:git_flutter_festou/src/models/card_model.dart';

class Pagamentos extends StatefulWidget {
  const Pagamentos({super.key});

  @override
  State<Pagamentos> createState() => _PagamentosState();
}

class _PagamentosState extends State<Pagamentos> {
  bool isExpanded = false;
  List<bool> selectedRows = [false, false, false];

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

  List<CardModel> cards = [];
  @override
  void initState() {
    getCards();
    super.initState();
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
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pix',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 17,
            ),
            MyRow(
              text: 'Pix',
              icon: Image.asset('lib/assets/images/Pix Imagepix.png'),
              onTap: () {},
              textColor: null,
            ),
            const SizedBox(height: 27),
            const Text(
              'Cartões',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 17,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  ExpansionTile(
                    clipBehavior: Clip.none,
                    trailing: Container(
                      color: Colors.transparent,
                      width: 1,
                      height: 1,
                    ),
                    collapsedShape: const RoundedRectangleBorder(
                      side: BorderSide.none,
                    ),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide.none,
                    ),
                    backgroundColor: const Color(0xff4300B1),
                    title: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                                'lib/assets/images/image 4carotn.png')),
                        const SizedBox(width: 10),
                        Text(
                          'Pagar com Cartao de crédito',
                          style: TextStyle(
                            fontSize: 12,
                            color: isExpanded ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      ...cards.map((card) {
                        return Column(
                          children: [
                            MyRow(
                              hasMargin: true,
                              color: Colors.white,
                              text: 'Cartao ${card.number.substring(0, 4)}',
                              icon: Image.asset(
                                  'lib/assets/images/image 4carotn.png'),
                              onTap: () {
                                Navigator.pop(context, card);
                              },
                              textColor: const Color(0xff4300B1),
                            ),
                          ],
                        );
                      }),

                      MyRow(
                        color: null,
                        text: 'Adicionar novo cartão de crédito',
                        icon:
                            Image.asset('lib/assets/images/image 4xxdfad.png'),
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
                        textColor: null,
                      ),
                      // Adicione mais opções conforme necessário
                    ],
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        isExpanded = expanded;
                      });
                    },
                  ),
                  if (isExpanded)
                    Positioned(
                      top: 43,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff4300B1),
                        ),
                        height: 20,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget MyRow({
    required String text,
    required Widget icon,
    required Function()? onTap,
    bool? hasMargin,
    Color? color,
    required Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasMargin == true)
            Container(
              color: const Color(0XFFF8F8F8),
              height: 20,
            ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: const Color(0XFFF8F8F8),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color ?? Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  icon,
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*
SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          backgroundColor: color ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
        ),
        onPressed: onTap,
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            Text(text),
          ],
        ),
      ),
    );
     */
/* */