import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class NewCardView extends StatelessWidget {
  const NewCardView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
          'Adicionar novo cartão',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: screenWidth / 2,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: const Color(0xff9747FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 31, right: 22, top: 22, bottom: 11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Festou',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: 50,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xffFF0000)
                                            .withOpacity(0.65),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xffFF7A00)
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                          const Text(
                            '7894 **** **** 2580',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PORTADOR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'EMILIA FARIA M SOUZA',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'VALIDADE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '01/29',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: screenWidth / 2.5,
                    width: screenWidth / 2.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: screenWidth / 8.5,
                  child: Container(
                    height: screenWidth / 2.5,
                    width: screenWidth / 2.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 45),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Column(
                children: [
                  MyRow(
                    text: 'Emília Faria M Souza',
                    icon: Image.asset('lib/assets/images/image 6pessoa.png'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),
                  MyRow(
                      text: '7894 1234 4568 2580',
                      icon: Image.asset('lib/assets/images/image 42card.png'),
                      onTap: () {}),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: MyRow(
                            text: '01/29',
                            icon: Image.asset(
                                'lib/assets/images/image 4calendar.png'),
                            onTap: () {}),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: MyRow(
                            text: '100',
                            icon:
                                Image.asset('lib/assets/images/image 5cvv.png'),
                            onTap: () {}),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  MyRow(
                    text: 'Cartão Master 2',
                    icon: Image.asset('lib/assets/images/image 7master2.png'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewCardView(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(bottom: 20, left: 30, right: 30, top: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: const Color(0xff9747FF),
              borderRadius: BorderRadius.circular(50)),
          child: const Text(
            'Adicionar cartão',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget MyRow(
      {required String text,
      required Widget icon,
      required Function()? onTap,
      Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color ?? Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 6),
              ),
            ]),
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
  }
}
