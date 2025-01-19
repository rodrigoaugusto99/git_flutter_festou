import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';

class CentralDeAjuda extends StatefulWidget {
  const CentralDeAjuda({super.key});

  @override
  State<CentralDeAjuda> createState() => _CentralDeAjudaState();
}

class _CentralDeAjudaState extends State<CentralDeAjuda>
    with SingleTickerProviderStateMixin {
  final duvidaEC = TextEditingController();
  final mensagemEC = TextEditingController();
  bool isExpanded = false;
  late Future<List<Map<String, dynamic>>> _questionsFuture;

  List<bool> selectedRows = [false, false, false];
  late AnimationController _animationController;
  late Animation<double> _iconRotationAnimation;

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .orderBy('order')
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'question': data['question'] ?? '',
        'response': data['response'] ?? '',
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _questionsFuture = fetchQuestions(); // Carrega as perguntas uma única vez
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
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    List<String> screenshots = ['Imagem_1.jpg', 'Imagem_2.jpg', 'Imagem_3.jpg'];
    //'Como posso alugar um espaço para realizar meu evento?',
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
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
          'Central de ajuda',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: y, // Define altura mínima
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 243, 243, 243), // Cinza claro
                      Color.fromARGB(255, 247, 247, 247), // Branco
                    ],
                    begin: Alignment.topCenter, // Início do gradiente
                    end: Alignment.bottomCenter, // Fim do gradiente
                  ),
                ),
                height: 151,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Como podemos lhe ajudar?',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10.0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Pesquise sua dúvida',
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.purple,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 20.0),
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      'lib/assets/images/logo_festou.png',
                      width: 100,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Perguntas Frequentes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _questionsFuture, // Usa o Future armazenado
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomLoadingIndicator();
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar as perguntas.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhuma pergunta encontrada.'));
                  }

                  final questions = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.only(left: 30, right: 10),
                    child: SizedBox(
                      height: 107,
                      child: ListView.builder(
                        shrinkWrap: true,
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final question = questions[index]['question']!;
                          return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: DuvidaWidget(
                              text: question,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Suporte',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Ainda precisa de ajuda?\nAbra seu chamado para o suporte Festou!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 41),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                        'lib/assets/images/Icon Calendar1ads.png',
                                        width: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Iniciar um chamado',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                RotationTransition(
                                  turns: _iconRotationAnimation,
                                  child: const Icon(
                                    Icons.expand_more,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded) // Conteúdo exibido quando o botão é expandido
                          Column(
                            children: <Widget>[
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: CustomTextformfield(
                                  label: 'Título',
                                  controller: duvidaEC,
                                  fillColor:
                                      const Color.fromARGB(255, 248, 248, 248),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: CustomTextformfield(
                                  label: 'Mensagem',
                                  controller: mensagemEC,
                                  isBig: true,
                                  fillColor:
                                      const Color.fromARGB(255, 248, 248, 248),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'Upload de imagens (máximo 3):',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 30.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        alignment: Alignment.center,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xff9747FF),
                                              Color(0xff44300b1),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.search,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: screenshots.map((x) {
                                    return Text(
                                      x,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.red),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15.0,
                                        left: 15.0,
                                        bottom: 15.0,
                                        top: 10.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff9747FF),
                                            Color(0xff44300b1),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: const Text(
                                        "Enviar",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class DuvidaWidget extends StatelessWidget {
  final String text;
  const DuvidaWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 107,
      width: 143,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: const Color(0xffF0F0F0),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}
