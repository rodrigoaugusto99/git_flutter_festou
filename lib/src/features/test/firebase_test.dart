import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/feedback/feedback_model_test.dart';
import 'package:git_flutter_festou/src/models/space/space_model_test2.dart';

class FirebaseTest extends StatefulWidget {
  const FirebaseTest({super.key});

  @override
  _FirebaseTestState createState() => _FirebaseTestState();
}

class _FirebaseTestState extends State<FirebaseTest> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController logradouroController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();

  List<SpaceModelTest> spaces = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    final space = db.collection("spaces");
    space.snapshots().listen((snapshot) {
      setState(() {
        spaces = snapshot.docs.map((doc) {
          final data = doc.data();
          return SpaceModelTest(
            name: data['name'] ?? '',
            email: data['email'] ?? '',
            cep: data['cep'] ?? '',
            logradouro: data['logradouro'] ?? '',
            numero: data['numero'] ?? '',
            bairro: data['bairro'] ?? '',
            cidade: data['cidade'] ?? '',
            selectedTypes: List<String>.from(data['selectedTypes'] ?? []),
            selectedServices: List<String>.from(data['selectedServices'] ?? []),
            availableDays: List<String>.from(data['availableDays'] ?? []),
            feedbackModel: (data['feedbackModel'] as List<dynamic>?)
                    ?.map((item) {
                  return FeedbackModel.fromMap(item as Map<String, dynamic>);
                }).toList() ??
                [],
          );
        }).toList();
      });
    });
  }

  void saveSpace() {
    // Criar um novo objeto SpaceModelTest2 com os dados dos controladores
    final newSpace = SpaceModelTest(
      name: nameController.text,
      email: emailController.text,
      cep: cepController.text,
      logradouro: logradouroController.text,
      numero: numeroController.text,
      bairro: bairroController.text,
      cidade: cidadeController.text,
      selectedTypes: [], // Preencha com os dados apropriados
      selectedServices: [], // Preencha com os dados apropriados
      availableDays: [], // Preencha com os dados apropriados
      feedbackModel: [], // Preencha com os dados apropriados
    );

    // Enviar o novo espaço para o Firestore
    db.collection("spaces").add(newSpace.toFirestore());

    // Limpar os controladores após salvar
    nameController.clear();
    emailController.clear();
    cepController.clear();
    logradouroController.clear();
    numeroController.clear();
    bairroController.clear();
    cidadeController.clear();

    // Atualizar a lista de espaços
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Cloud Firestore Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: cepController,
              decoration: const InputDecoration(labelText: 'CEP'),
            ),
            TextField(
              controller: logradouroController,
              decoration: const InputDecoration(labelText: 'Logradouro'),
            ),
            TextField(
              controller: numeroController,
              decoration: const InputDecoration(labelText: 'Número'),
            ),
            TextField(
              controller: bairroController,
              decoration: const InputDecoration(labelText: 'Bairro'),
            ),
            TextField(
              controller: cidadeController,
              decoration: const InputDecoration(labelText: 'Cidade'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: saveSpace,
              child: const Text('Salvar Espaço'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Espaços Disponíveis:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: spaces.length,
              itemBuilder: (context, index) {
                final space = spaces[index];
                return ListTile(
                  title: Text('Nome: ${space.name}'),
                  subtitle: Text(
                    'Email: ${space.email}\n'
                    'CEP: ${space.cep}\n'
                    'Logradouro: ${space.logradouro}\n'
                    'Número: ${space.numero}\n'
                    'Bairro: ${space.bairro}\n'
                    'Cidade: ${space.cidade}\n'
                    'Selected Types: ${space.selectedTypes!.join(", ")}\n'
                    'Selected Services: ${space.selectedServices!.join(", ")}\n'
                    'Available Days: ${space.availableDays!.join(", ")}\n'
                    'Feedback Models: ${space.feedbackModel!.map((feedback) => 'Rating: ${feedback.rating}, Content: ${feedback.content}').join("\n")}',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
