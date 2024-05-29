import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/widgets/my_rows_config.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  late Future<UserModel?> userFuture;
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    userFuture = userService.getCurrentUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: FutureBuilder<UserModel?>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Erro ao carregar dados do usuário'));
          } else if (snapshot.hasData && snapshot.data != null) {
            UserModel user = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Configurações',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                MyRowsConfig(
                  userModel: user,
                ),
              ],
            );
          } else {
            return const Center(child: Text('Usuário não encontrado'));
          }
        },
      ),
    );
  }
}
