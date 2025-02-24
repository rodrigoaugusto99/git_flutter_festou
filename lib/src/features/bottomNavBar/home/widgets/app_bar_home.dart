import 'package:festou/src/features/space%20card/widgets/notificacoes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:festou/src/services/user_service.dart';

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
      automaticallyImplyLeading: false,
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
                        userModel != null
                            ? userService.getAvatar(userModel!)
                            : const CircularProgressIndicator(),
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
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        //color: Colors.white.withOpacity(0.7),
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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NotificacoesPage(locador: false),
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
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
