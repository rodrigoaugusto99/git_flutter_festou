import 'package:carousel_slider/carousel_slider.dart';
import 'package:festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/features/register/space/space%20temporary/pages/new_space_register.dart';
import 'package:festou/src/features/space%20card/widgets/my_sliver_list_to_card_info.dart';
import 'package:festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_state.dart';
import 'package:festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_vm.dart';
import 'package:festou/src/features/space%20card/widgets/notificacoes_page.dart';
import 'package:festou/src/helpers/keys.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:festou/src/services/user_service.dart';

class MySpacesPage extends ConsumerStatefulWidget {
  const MySpacesPage({super.key});

  @override
  ConsumerState<MySpacesPage> createState() => _MySpacesPageState();
}

class _MySpacesPageState extends ConsumerState<MySpacesPage> {
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

  int currentSlide = 0;
  @override
  Widget build(BuildContext context) {
    final mySpaces = ref.watch(mySpacesVmProvider);

    final errorMessager = ref.watch(mySpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (errorMessager.toString() != '') {
        Messages.showError(errorMessager, context);
      }
    });

    List<String> images = [
      'lib/assets/images/banner_dica.png',
      'lib/assets/images/banner_destaque.png',
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        userModel: userModel,
      ),
      body: mySpaces.when(
        data: (MySpacesState data) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CarouselSlider(
                      items: images.map((imagePath) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Image.asset(
                            imagePath,
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentSlide = index;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images.map((url) {
                        int index = images.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentSlide == index
                                ? const Color(0xff9747FF)
                                : Colors.grey.shade300,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Cadastrar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: InkWell(
                      key: Keys.kLocadorViewRegisterSpace,
                      onTap: () {
                        ref.read(newSpaceRegisterVmProvider.notifier).reset();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewSpaceRegister(),
                          ),
                        );
                      },
                      child:
                          Image.asset('lib/assets/images/banner_cadastre.png')),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text('Meus espaços ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: MySliverListToCardInfo(
                    isLocadorFlow: true,
                    spaces: data.spaces,
                    x: false,
                  ),
                ),
              ],
            ),
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return const Stack(children: [
            Center(child: Icon(Icons.error)),
          ]);
        },
        loading: () {
          return const Stack(children: [
            Center(child: CustomLoadingIndicator()),
          ]);
        },
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel? userModel;
  final userService = UserService();

  CustomAppBar({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  userModel != null
                      ? userService.getAvatar(userModel!)
                      : const CustomLoadingIndicator(),
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
              padding: const EdgeInsets.only(right: 18.0),
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
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotificacoesPage(
                      locador: true,
                    ),
                  )),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75.0);
}
