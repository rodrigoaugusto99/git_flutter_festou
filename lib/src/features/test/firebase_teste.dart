import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirebaseTeste extends StatefulWidget {
  const FirebaseTeste({super.key});

  @override
  State<FirebaseTeste> createState() => _FirebaseTesteState();
}

class _FirebaseTesteState extends State<FirebaseTeste> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final nameEC = TextEditingController();
  final ageEC = TextEditingController();
  final cpfEC = TextEditingController();
  List<Map<String, dynamic>> contactList = [];

  @override
  void initState() {
    refresh();
    super.initState();
  }

//listener para ouvir as alterações do firestore 24/7
  void refresh() {
    final contacts = db.collection("contatos");
    contacts.snapshots().listen((snapshot) {
      setState(() {
        contactList = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

//salvando na coleção "contatos" com "id" no documento o mapa
  void save() {
    String id = const Uuid().v1();
    db.collection("contatos").doc(id).set({
      "name": nameEC.text,
      "age": ageEC.text,
      "cpf": cpfEC.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: refresh),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: nameEC,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              TextField(
                controller: ageEC,
                decoration: const InputDecoration(hintText: 'Age'),
              ),
              TextField(
                controller: cpfEC,
                decoration: const InputDecoration(hintText: 'CPF'),
              ),
              ElevatedButton(
                onPressed: save,
                child: const Text('Salvar'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    final name = contact['name'];
                    final age = contact['age'];
                    final cpf = contact['cpf'];

                    return ListTile(
                      title: Text('Name: $name'),
                      subtitle: Text('Age: $age, CPF: $cpf'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
