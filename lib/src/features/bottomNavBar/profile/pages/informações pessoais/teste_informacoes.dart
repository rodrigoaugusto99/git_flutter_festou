import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class TesteInformacoes extends StatefulWidget {
  const TesteInformacoes({super.key});

  @override
  State<TesteInformacoes> createState() => _TesteInformacoesState();
}

class _TesteInformacoesState extends State<TesteInformacoes> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: storage
          .ref()
          .child('path/to/your/storage/object')
          .listAll()
          .asStream(),
      builder: (context, AsyncSnapshot<ListResult> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Mostra um indicador de carregamento enquanto os dados estão sendo buscados.
        }

        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
          return const Text('Nenhum dado encontrado.');
        }

        // Aqui você pode acessar os itens da lista e construir sua interface de usuário.
        final items = snapshot.data!.items;
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Item ${index + 1}'),
              subtitle: Text('URL: ${items[index].getDownloadURL()}'),
            );
          },
        );
      },
    );
  }
}
