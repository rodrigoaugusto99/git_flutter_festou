import 'package:flutter/material.dart';

class CuponsEPromocoes extends StatefulWidget {
  const CuponsEPromocoes({super.key});

  @override
  State<CuponsEPromocoes> createState() => _CuponsEPromocoesState();
}

class _CuponsEPromocoesState extends State<CuponsEPromocoes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 219,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(8)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 26,
            left: 18,
            child: RichText(
              text: const TextSpan(
                text: 'Os melhores ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'cupons\n',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'e os ',
                  ),
                  TextSpan(
                    text: 'maiores\ndescontos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 40,
            left: 18,
            child: Text(
              'Você só encontra\nna',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: -25,
            top: 0,
            bottom: 0,
            child: Image.asset(
                'lib/assets/images/homem-afro-americano-verificando-seu-smartphone 1homem_iphhone.png'),
          )
        ],
      ),
    );
  }
}
