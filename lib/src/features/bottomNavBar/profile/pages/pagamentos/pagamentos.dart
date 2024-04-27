import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/pagamentos/new_card_view.dart';

class Pagamentos extends StatefulWidget {
  const Pagamentos({super.key});

  @override
  State<Pagamentos> createState() => _PagamentosState();
}

class _PagamentosState extends State<Pagamentos> {
  @override
  Widget build(BuildContext context) {
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
          'Metodos de Pagamento',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyRow(
              text: 'Pix',
              icon: Image.asset('lib/assets/images/Pix Imagepix.png'),
              onTap: () {},
            ),
            const SizedBox(height: 15),
            MyRow(
                color: const Color(0xff9747FF),
                text: 'Cartao de crédito',
                icon: Image.asset('lib/assets/images/image 4carotn.png'),
                onTap: () {}),
            const SizedBox(height: 15),
            MyRow(
                color: const Color(0xff9747FF),
                text: 'Cartão Master',
                icon: Image.asset('lib/assets/images/image 4carotn.png'),
                onTap: () {}),
            const SizedBox(height: 15),
            MyRow(
                text: 'Cartão Visa',
                icon: Image.asset('lib/assets/images/image 4carotn.png'),
                onTap: () {}),
            const SizedBox(height: 15),
            MyRow(
              text: 'Adicionar novo cartão de crédito',
              icon: Image.asset('lib/assets/images/image 4xxdfad.png'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewCardView(),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
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
        height: 50,
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
