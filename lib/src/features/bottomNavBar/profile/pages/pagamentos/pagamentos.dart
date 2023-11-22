import 'package:flutter/material.dart';

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
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pagamentos',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Viagem',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            MyRow(
                text: 'Formas de pagamento',
                icon: const Icon(Icons.data_array),
                onTap: () {}),
            MyRow(
                text: 'Seus pagamentos',
                icon: const Icon(Icons.data_array),
                onTap: () {}),
            MyRow(
                text: 'Créditos e cupons pagamentos',
                icon: const Icon(Icons.data_array),
                onTap: () {}),
            const Text(
              'Hospedagem',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            MyRow(
                text: 'Formas de pagamento',
                icon: const Icon(Icons.data_array),
                onTap: () {}),
            MyRow(
                text: 'Historico de transações',
                icon: const Icon(Icons.data_array),
                onTap: () {}),
            MyRow(
                text: 'Doações',
                icon: const Icon(Icons.data_array),
                onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget MyRow(
      {required String text, required Icon icon, required Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.icecream),
                  Text(text),
                ],
              ),
              const Icon(Icons.arrow_circle_right_rounded),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
