import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festou/src/helpers/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/central/perguntas_frequentes.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/central/widget/question.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/features/widgets/custom_textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:intl/intl.dart';

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
  int ticketsToShow = 3;
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

  FocusNode focusNode = FocusNode();

  Widget _buildSearchBox(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        focusNode: focusNode,
        onTapOutside: (v) {
          focusNode.unfocus(); // Primeiro desfoca o campo

          Future.delayed(const Duration(milliseconds: 300), () {
            filteredQuestions.clear(); // Limpa a lista após o desfocar
            setState(() {}); // Atualiza a interface uma única vez
          });
        },
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

  Future<List<Map<String, dynamic>>> fetchUserTickets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado.')),
      );
      return [];
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': data['id'],
        'title': data['title'] ?? 'Sem título',
        'message': data['message'] ?? 'Sem mensagem',
        'images': data['images'] ?? [],
        'status': data['status'] ?? 'Aberto',
        'createdAt': data['createdAt'],
        'response': data['response'] ?? '',
        'cancelReason': data['cancelReason'] ?? '',
      };
    }).toList();
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
      await showLoading(context);

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
        'status': 'Opened',
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
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar chamado: $e')),
      );
    } finally {
      dismissLoading(context);
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

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'inprogress':
        return Colors.green;
      case 'onhold':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'opened':
      default:
        return Colors.grey;
    }
  }

  // Função para converter status em texto amigável
  String getStatus(String status) {
    switch (status.toLowerCase()) {
      case 'inprogress':
        return 'Em análise';
      case 'onhold':
        return 'Em espera';
      case 'completed':
        return 'Concluído';
      case 'cancelled':
        return 'Cancelado';
      case 'opened':
      default:
        return 'Aberto';
    }
  }

  void _showTicketDetails(BuildContext context, Map<String, dynamic> ticket) {
    final x = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Número do ticket
                  Center(
                    child: Text(
                      'Ticket ${ticket['id']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Título do ticket
                  Text(
                    ticket['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // Data e hora de abertura
                      Text(
                        'Aberto em:\n${DateFormat('dd/MM/yyyy HH:mm').format(ticket['createdAt'].toDate())}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      // Status do ticket
                      Padding(
                        padding: EdgeInsets.only(left: x * 0.22),
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: getStatusColor(ticket['status']),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            getStatus(ticket['status']).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Descrição do ticket
                  const Text(
                    'Descrição:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Scrollbar(
                    child: TextField(
                      controller:
                          TextEditingController(text: ticket['message']),
                      readOnly: true, // Impede edição do texto
                      maxLines: 8, // Permite múltiplas linhas
                      minLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none, // Remove a linha inferior
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Exibir imagens se existirem
                  if (ticket['images'] != null && ticket['images'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Imagens anexadas:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              List.generate(ticket['images'].length, (index) {
                            String imageUrl = ticket['images'][index];
                            return GestureDetector(
                              onTap: () {
                                List<String> imageUrls =
                                    List<String>.from(ticket['images']);
                                _showImageGallery(context, imageUrls, index);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                  // Exibir resposta se existir e não estiver em análise ou aberto
                  if (ticket['status'].toLowerCase() == 'completed' ||
                      ticket['status'].toLowerCase() == 'onhold')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resposta:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Scrollbar(
                          child: TextField(
                            controller: TextEditingController(
                                text: ticket['response'] == ''
                                    ? 'Ainda não foi respondido.'
                                    : ticket['response']),
                            readOnly: true, // Impede edição do texto
                            maxLines: 8, // Permite múltiplas linhas
                            minLines: 1,
                            decoration: const InputDecoration(
                              border:
                                  InputBorder.none, // Remove a linha inferior
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                  // Exibir resposta se existir e não estiver em análise ou aberto
                  if (ticket['status'].toLowerCase() == 'cancelled')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Motivo de cancelamento:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Scrollbar(
                          child: TextField(
                            controller: TextEditingController(
                                text: ticket['cancelReason']),
                            readOnly: true, // Impede edição do texto
                            maxLines: 8, // Permite múltiplas linhas
                            minLines: 1,
                            decoration: const InputDecoration(
                              border:
                                  InputBorder.none, // Remove a linha inferior
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                  // Botões Cancelar e Fechar
                  Row(
                    mainAxisAlignment:
                        ticket['status'].toLowerCase() != 'completed' &&
                                ticket['status'].toLowerCase() != 'cancelled'
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                    children: [
                      // Botão Cancelar Ticket (se não estiver concluído ou cancelado)
                      if (ticket['status'].toLowerCase() != 'completed' &&
                          ticket['status'].toLowerCase() != 'cancelled')
                        ElevatedButton(
                          onPressed: () {
                            _showCancelTicketPopup(context, ticket['id']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Cancelar Ticket'),
                        ),

                      // Botão Fechar
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Fechar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Função para mostrar o popup de cancelamento
  void _showCancelTicketPopup(BuildContext context, String ticketId) {
    TextEditingController motivoCancelamentoEC = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botão de fechar no canto superior direito
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cancelar Ticket',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Campo de texto para motivo do cancelamento
                TextField(
                  controller: motivoCancelamentoEC,
                  decoration: const InputDecoration(
                    hintText: 'Informe o motivo do cancelamento',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),

                // Botão de confirmação de cancelamento
                Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (motivoCancelamentoEC.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Por favor, informe um motivo para cancelamento.'),
                          ),
                        );
                        return;
                      }

                      _cancelTicket(
                          context, ticketId, motivoCancelamentoEC.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Confirmar Cancelamento'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _cancelTicket(
      BuildContext context, String ticketId, String motivo) async {
    try {
      // Consulta para encontrar o documento pelo campo "id"
      var querySnapshot = await FirebaseFirestore.instance
          .collection('tickets')
          .where('id', isEqualTo: ticketId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Obtém o ID do documento real no Firestore
        String documentId = querySnapshot.docs.first.id;

        // Atualiza o documento encontrado
        await FirebaseFirestore.instance
            .collection('tickets')
            .doc(documentId)
            .update({
          'status': 'cancelled',
          'cancelReason': motivo,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket cancelado com sucesso.')),
        );

        // Fecha os dois diálogos
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        setState(() {
          // Refetch os tickets para refletir as alterações na UI
          fetchUserTickets();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket não encontrado.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cancelar o ticket: $e')),
      );
    }
  }

  void _showImageGallery(
      BuildContext context, List<String> images, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            // Galeria de imagens
            PhotoViewGallery.builder(
              itemCount: images.length,
              pageController: PageController(initialPage: initialIndex),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(images[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
            ),

            // Botão de voltar
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.close, size: 30, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _questionsFuture,
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
                        final limitedQuestions = snapshot.data!.length > 3
                            ? snapshot.data!.sublist(0, 3)
                            : snapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.only(left: 30, right: 10),
                          child: SizedBox(
                            height: 107,
                            child: ListView.builder(
                              shrinkWrap: true,
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemCount: limitedQuestions.length + 1,
                              itemBuilder: (context, index) {
                                if (index < limitedQuestions.length) {
                                  final question =
                                      limitedQuestions[index]['question'];
                                  final response =
                                      limitedQuestions[index]['response'];

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: QuestionWidget(
                                      text: question,
                                      response: response,
                                    ),
                                  );
                                } else {
                                  // Botão "Ver mais"
                                  return SizedBox(
                                    height: 250,
                                    width: 170,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return PerguntasFrequentes(
                                                  perguntas: snapshot.data!);
                                            },
                                          ),
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Ver todos',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, top: 2),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 15,
                                                color: Color(0xff4300B1),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
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
                                              'lib/assets/images/icon-chamado.png',
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
                                                              'lib/assets/images/icon_lixeira.png',
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
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Meus Tickets',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchUserTickets(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return const Center(child: CustomLoadingIndicator());
                        // }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Erro ao carregar os tickets.'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              'Você não abriu nenhum ticket ainda.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        }

                        final tickets = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16.0, bottom: 16.0),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    ticketsToShow.clamp(0, tickets.length),
                                itemBuilder: (context, index) {
                                  final ticket = tickets[index];

                                  return GestureDetector(
                                    onTap: () => _showTicketDetails(context,
                                        ticket), // Exibir pop-up ao clicar
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            // Imagem de fundo com transparência
                                            Positioned.fill(
                                              child: Opacity(
                                                opacity:
                                                    0.08, // Define a transparência da logo
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Image.asset(
                                                    'lib/assets/images/logo_festou.png',
                                                    width:
                                                        100, // Ajuste o tamanho conforme necessário
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24.0,
                                                      vertical: 16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Título do ticket
                                                  Text(
                                                    ticket['title'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),

                                                  // Mensagem do ticket
                                                  Text(
                                                    ticket['message'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(height: 10),

                                                  // ID e Data
                                                  Text(
                                                    'ID: ${ticket['id']}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Criado em: ${DateFormat('dd/MM/yyyy').format(ticket['createdAt'].toDate())} às ${DateFormat('HH:mm').format(ticket['createdAt'].toDate())}h',
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(height: 10),

                                                  // Status do ticket com retângulo e bordas arredondadas
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 100,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 6,
                                                        horizontal: 12),
                                                    decoration: BoxDecoration(
                                                      color: getStatusColor(
                                                          ticket['status']),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Text(
                                                      getStatus(
                                                              ticket['status'])
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Efeito de "ingresso" recortado nas laterais
                                            Positioned(
                                              left: -10,
                                              top: 30,
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 247, 247, 247),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: -10,
                                              top: 30,
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 247, 247, 247),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (ticketsToShow < tickets.length)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      ticketsToShow +=
                                          3; // Carrega mais 3 tickets
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Ver mais',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 5, top: 2),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 25,
                                            color: Color(0xff4300B1),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    )
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
