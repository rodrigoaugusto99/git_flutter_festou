import 'package:flutter/material.dart';

class NotificacoesPage extends StatelessWidget {
  const NotificacoesPage({super.key});

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
          centerTitle: true,
          title: const Text(
            'Notificações',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: const Column(
          children: [
            NotificacoesWidget(
              path: 'lib/assets/images/image 14not1.png',
              text1: 'Sua reserva está confirmada!',
              text2:
                  'Espaço Feliz LTDA confirmou sua reserva parao dia 10/01/2025 às 17:00h.',
              time: '1d',
            ),
            NotificacoesWidget(
              path: 'lib/assets/images/image 15not2.png',
              text1: 'Espaço Feliz LTDA enviou uma mensagem!',
              text2:
                  'Olá, Ellen, compartilhe esse momento especial com você e seus...',
              time: '1d',
            ),
            NotificacoesWidget(
              path: 'lib/assets/images/image 16nor3.png',
              text1: 'Avalie sua experiência!',
              text2:
                  'Conte-nos como foi sua experiência com Rio Top Eventos e envie sua avalição.',
              time: '3m',
            ),
          ],
        ));
  }
}

class NotificacoesWidget extends StatelessWidget {
  final String path;
  final String text1;
  final String text2;
  final String time;
  const NotificacoesWidget({
    super.key,
    required this.path,
    required this.text1,
    required this.text2,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 103,
      child: Row(
        children: [
          Image.asset(path),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      text1,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(time),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  text2,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
