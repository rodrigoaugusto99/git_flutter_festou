import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';
import '../../../../core/providers/application_providers.dart';

class AppBarHome extends ConsumerStatefulWidget {
  const AppBarHome({super.key});

  @override
  ConsumerState<AppBarHome> createState() => _AppBarMenuSpaceTypesState();
}

class _AppBarMenuSpaceTypesState extends ConsumerState<AppBarHome> {
  UserService userService = UserService();
  UserModel? userModel;

  @override
  void initState() {
    getUserModel();
    super.initState();
  }

  Future<void> getUserModel() async {
    userModel = await userService.getCurrentUserModel();
    setState(() {});
  }

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
                    child: Row(
                      children: [
                        if (userModel != null)
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 27,
                                backgroundImage:
                                    NetworkImage(userModel!.avatarUrl),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Olá, ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: userModel != null
                                    ? userModel!.name.split(" ")[0]
                                    : "Usuário",
                                style: const TextStyle(
                                  color: Color(0xff6100FF), // Cor roxa
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: '! Festou?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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
