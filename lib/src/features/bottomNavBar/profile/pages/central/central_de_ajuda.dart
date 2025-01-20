import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';
import 'package:image_picker/image_picker.dart';

class CentralDeAjuda extends StatefulWidget {
  const CentralDeAjuda({super.key});

  @override
  State<CentralDeAjuda> createState() => _CentralDeAjudaState();
}

class _CentralDeAjudaState extends State<CentralDeAjuda>
    with SingleTickerProviderStateMixin {
  final duvidaEC = TextEditingController();
  final mensagemEC = TextEditingController();
  final searchEC = TextEditingController();
  bool isExpanded = false;
  late Future<List<Map<String, dynamic>>> _questionsFuture;
  List<Map<String, dynamic>> allQuestions = [];
  List<Map<String, dynamic>> filteredQuestions = [];

  List<bool> selectedRows = [false, false, false];
  late AnimationController _animationController;
  late Animation<double> _iconRotationAnimation;
  List<File> _images = [];
  int? _selectedImageIndex;
  late LayerLink _layerLink;

  @override
  void initState() {
    super.initState();
    _layerLink = LayerLink();
    _questionsFuture = fetchQuestions().then((questions) {
      setState(() {
        allQuestions = questions;
      });
      return allQuestions;
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _iconRotationAnimation =
        Tween<double>(begin: 0, end: 0.5).animate(_animationController);

    searchEC.addListener(() {
      filterQuestions(searchEC.text);
    });

    filteredQuestions = [];
  }

  Widget _buildSearchBox(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: searchEC,
        decoration: InputDecoration(
          hintText: 'Pesquise sua dúvida',
          prefixIcon: const Icon(Icons.search, color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .orderBy('order')
        .get();

    final questions = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'question': data['question'] ?? '',
        'response': data['response'] ?? '',
      };
    }).toList();

    setState(() {
      allQuestions = questions; // Armazena todas as perguntas carregadas
    });

    return questions;
  }

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if ((_images.length + pickedFiles.length) > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione no máximo 3 imagens.')),
      );
    } else {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      _selectedImageIndex = null;
    });
  }

  Future<void> _submitTicket() async {
    if (duvidaEC.text.isEmpty || mensagemEC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado.')),
        );
        return;
      }

      // Obtém o próximo ID do ticket
      String ticketId = await _generateTicketId();

      List<String> imageUrls = [];

      for (var image in _images) {
        final ref = FirebaseStorage.instance.ref().child(
            'tickets/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}');
        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      await FirebaseFirestore.instance.collection('tickets').add({
        'id': ticketId,
        'title': duvidaEC.text,
        'message': mensagemEC.text,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'images': imageUrls,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Seu ticket foi aberto! Aguarde a resposta em até 3 dias úteis via e-mail. Ticket ID $ticketId',
          ),
        ),
      );

      duvidaEC.clear();
      mensagemEC.clear();
      setState(() {
        _images = [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar chamado: $e')),
      );
    }
  }

  void _showQuestionDialog(
      BuildContext context, String question, String answer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question),
        content: Text(answer),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<String> _generateTicketId() async {
    final firestore = FirebaseFirestore.instance;
    final counterRef = firestore.collection('ticket_counters').doc('counter');

    return await firestore.runTransaction((transaction) async {
      final counterSnapshot = await transaction.get(counterRef);

      int lastId;
      if (counterSnapshot.exists) {
        lastId = counterSnapshot['lastId'] as int;
      } else {
        lastId = 100100; // Valor inicial
      }

      int newId = lastId + 1;

      transaction.set(counterRef, {'lastId': newId});

      return '#$newId';
    });
  }

  void filterQuestions(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredQuestions = [];
      } else {
        filteredQuestions = allQuestions.where((question) {
          return question['question']
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        if (_selectedImageIndex != null) {
          setState(() {
            _selectedImageIndex = null;
          });
        }
      },
      child: Scaffold(
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
            'Central de ajuda',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
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
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      height: 151,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Como podemos lhe ajudar?',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 40,
                                    child: _buildSearchBox(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            'lib/assets/images/logo_festou.png',
                            width: 100,
                          ),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CustomLoadingIndicator();
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Erro ao carregar as perguntas.'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
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
                                final response = questions[index]['response']!;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: DuvidaWidget(
                                    text: question,
                                    response: response,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        fillColor: const Color.fromARGB(
                                            255, 248, 248, 248),
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
                                        fillColor: const Color.fromARGB(
                                            255, 248, 248, 248),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Text(
                                            'Upload de imagens (máx. 3):',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 35.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              _pickImages();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
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
                                      height: 20,
                                    ),
                                    _images.isNotEmpty
                                        ? Wrap(
                                            spacing: 8,
                                            children: List.generate(
                                                _images.length, (index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedImageIndex = index;
                                                  });
                                                },
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    ColorFiltered(
                                                      colorFilter:
                                                          _selectedImageIndex ==
                                                                  index
                                                              ? ColorFilter.mode(
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  BlendMode
                                                                      .srcATop)
                                                              : const ColorFilter
                                                                  .mode(
                                                                  Colors
                                                                      .transparent,
                                                                  BlendMode
                                                                      .dst),
                                                      child: Image.file(
                                                        _images[index],
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    if (_selectedImageIndex ==
                                                        index)
                                                      Positioned(
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              _removeImage(
                                                                  index),
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Colors.red,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Image.asset(
                                                              'lib/assets/images/Ellipse 37lixeira-foto.png',
                                                              width: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          )
                                        : const Text(
                                            "Se necessário, selecione até 3 imagens",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _submitTicket();
                                      },
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
                                            child: const Text(
                                              "Abrir ticket",
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
            if (filteredQuestions.isNotEmpty && searchEC.text.isNotEmpty)
              Positioned(
                width: MediaQuery.of(context).size.width * 0.9,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  offset: const Offset(0, 45),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredQuestions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(filteredQuestions[index]['question']),
                            onTap: () {
                              _showQuestionDialog(
                                context,
                                filteredQuestions[index]['question'],
                                filteredQuestions[index]['response'],
                              );
                              searchEC.clear();
                              setState(() {
                                filteredQuestions = [];
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DuvidaWidget extends StatelessWidget {
  final String text;
  final String response;

  const DuvidaWidget({
    super.key,
    required this.text,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showQuestionDialog(context, text, response);
      },
      child: Container(
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
      ),
    );
  }

  void _showQuestionDialog(
      BuildContext context, String question, String answer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question),
        content: Text(answer),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
