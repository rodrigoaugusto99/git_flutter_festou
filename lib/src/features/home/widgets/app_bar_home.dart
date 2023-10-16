import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/application_providers.dart';

class AppBarHome extends ConsumerStatefulWidget {
  const AppBarHome({super.key});

  @override
  ConsumerState<AppBarHome> createState() => _AppBarMenuSpaceTypesState();
}

class _AppBarMenuSpaceTypesState extends ConsumerState<AppBarHome> {
  final user = FirebaseAuth.instance.currentUser!;

  String formatString(String input) { // TODO: Apagar este método ao adicionar a busca do nome do usuário no banco
    if (input.isEmpty) return '';

    // Limita a string a 6 caracteres
    String truncated = input.length > 6 ? input.substring(0, 6) : input;

    // Converte a primeira letra para maiúscula e o restante para minúscula
    return truncated[0].toUpperCase() + truncated.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: x * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Olá, ${formatString(user.email!)}! Festou?', // TODO: Buscar o nome do usuário direto de users/
                      // user_infos no banco
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      ref.read(logoutProvider.future);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      pinned: false,
    );
  }
}