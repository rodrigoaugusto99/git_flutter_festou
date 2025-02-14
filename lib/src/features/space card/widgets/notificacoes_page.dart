import 'package:festou/src/features/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:festou/src/services/user_service.dart';

class NotificacoesPage extends StatefulWidget {
  final bool locador;
  const NotificacoesPage({super.key, this.locador = false});

  @override
  _NotificacoesPageState createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  late List<Map<String, String>> notificacoes;

  @override
  void initState() {
    super.initState();
    notificacoes =
        widget.locador ? _notificacoesLocador() : _notificacoesPadrao();
  }

  List<Map<String, String>> _notificacoesPadrao() {
    return [
      {
        "path": 'lib/assets/images/image_reserva.png',
        "text1": 'Sua reserva está confirmada!',
        "text2":
            'Espaço Feliz LTDA confirmou sua reserva para o dia 10/01/2025 às 17:00h.',
        "time": '1d',
      },
      {
        "path": 'lib/assets/images/image_chat.png',
        "text1": 'Espaço Feliz LTDA enviou uma mensagem!',
        "text2":
            'Olá, compartilhar esse momento especial com você e seus convidados ser...',
        "time": '1d',
      },
      {
        "path": 'lib/assets/images/image_estrela.png',
        "text1": 'Avalie sua experiência!',
        "text2":
            'Conte-nos como foi sua experiência com Rio Top Eventos e envie sua avaliação.',
        "time": '3m',
      },
    ];
  }

  List<Map<String, String>> _notificacoesLocador() {
    return [
      {
        "path": 'lib/assets/images/image_reserva.png',
        "text1": 'Nova reserva recebida!',
        "text2":
            'Você recebeu uma nova reserva para o dia 10/01/2025 às 17:00h.',
        "time": '1d',
      },
      {
        "path": 'lib/assets/images/image_chat.png',
        "text1": 'Nova mensagem do cliente!',
        "text2": 'João enviou uma mensagem sobre a reserva do seu espaço.',
        "time": '1d',
      },
      {
        "path": 'lib/assets/images/image_estrela.png',
        "text1": 'Recebemos uma nova avaliação!',
        "text2": 'O cliente João avaliou o seu espaço, confira agora.',
        "time": '3m',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Container(
            decoration: BoxDecoration(
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
        centerTitle: true,
        title: const Text(
          'Notificações',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<UserModel?>(
        future: UserService().getCurrentUserModel(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading user'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const CustomLoadingIndicator();
          } else {
            return ListView.builder(
              itemCount: notificacoes.length,
              itemBuilder: (context, index) {
                final notificacao = notificacoes[index];
                return Dismissible(
                  key: Key(notificacao['text1']!),
                  direction: DismissDirection
                      .horizontal, // Permite deslizar para ambos os lados
                  onDismissed: (direction) {
                    // Remover a notificação da lista
                    setState(() {
                      notificacoes.removeAt(index);
                    });
                  },
                  background: Container(
                    alignment: Alignment.centerLeft,
                    color: const Color.fromARGB(255, 243, 243, 243),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    color: const Color.fromARGB(255, 243, 243, 243),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  child: NotificacoesWidget(
                    path: notificacao['path']!,
                    text1: notificacao['text1']!,
                    text2: notificacao['text2']!,
                    time: notificacao['time']!,
                  ),
                );
              },
            );
          }
        },
      ),
    );
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      text1,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text(time, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  text2,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
