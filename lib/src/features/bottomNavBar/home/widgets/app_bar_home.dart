import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/application_providers.dart';

class AppBarHome extends ConsumerStatefulWidget {
  const AppBarHome({super.key});

  @override
  ConsumerState<AppBarHome> createState() => _AppBarMenuSpaceTypesState();
}

class _AppBarMenuSpaceTypesState extends ConsumerState<AppBarHome> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.symmetric(horizontal: x * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Olá, ${user.displayName}! Festou?',
                      // user_infos no banco
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      ref.invalidate(userFirestoreRepositoryProvider);
                      ref.invalidate(userAuthRepositoryProvider);
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
