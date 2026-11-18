import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/features/bottomNavBar/bottom_navbar_locatario_page.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/central/central_de_ajuda.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/widgets/logout_dialog.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/widgets/my_row.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/register_signature.dart';
import 'package:festou/src/features/bottomNavBarLocador/bottom_navbar_locador_page.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/features/space%20card/widgets/privacy_policy_page.dart';
import 'package:festou/src/features/space%20card/widgets/service_terms_page.dart';
import 'package:festou/src/features/widgets/my_rows_config.dart';
import 'package:festou/src/helpers/keys.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festou/src/services/user_service.dart';
import 'package:lottie/lottie.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    userModel = await UserService().getCurrentUserModel();
    setState(() {});
  }

  Future<bool> hasActiveContract(String clientId) async {
    final now = DateTime.now();
    final querySnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .where('client_id', isEqualTo: clientId)
        .get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final selectedFinalDate = data['selectedFinalDate'].toDate();
      // final selectedFinalDate = data['selectedFinalDate'];
      final checkOutTime = data['checkOutTime'];

      if (selectedFinalDate.isAfter(now) && data['canceledAt'] == null) {
        return true;
      }
    }
    return false;
  }

  void navigateBasedOnContract(BuildContext context) async {
    if (userModel == null) return;

    if (userModel!.locador) {
      final hasSpaces = await hasRegisteredSpaces(userModel!.uid);

      if (hasSpaces) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'lib/assets/animations/warning.json',
                      width: 80,
                      height: 80,
                      repeat: false,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Espaços cadastrados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Você possui espaços cadastrados, por isso não é possível alterar o tipo de conta para locatário.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'lib/assets/animations/warning.json',
                      width: 80,
                      height: 80,
                      repeat: false,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Confirmação de Mudança',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Você não poderá mais disponibilizar espaços a partir da mudança, podendo apenas alugar. Deseja continuar?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomNavBarLocatarioPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Confirmar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } else {
      final hasContract = await hasActiveContract(userModel!.uid);

      if (hasContract) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'lib/assets/animations/info.json',
                      width: 120,
                      height: 120,
                      repeat: false,
                    ),
                    const Text(
                      'Contrato de Locação Ativo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Você possui um contrato de locação ativo e não pode mudar para locador.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'lib/assets/animations/warning.json',
                      width: 80,
                      height: 80,
                      repeat: false,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Confirmação de Mudança',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Você não poderá mais alugar espaços a partir da mudança, podendo apenas disponibilizar. Deseja continuar?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            key: Keys.kDialogConfirm,
                            onPressed: () async {
                              final response = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterSignature(),
                                ),
                              );
                              if (response == null) return;
                              if (response) {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavBarLocadorPage(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Confirmar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  Future<bool> hasRegisteredSpaces(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('spaces')
        .where('user_id', isEqualTo: userId)
        .where('deletedAt', isNull: true)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAF7FC);
    const ink = Color(0xFF1C1426);
    const muted = Color(0xFF8A8096);
    const accent = Color(0xFF7C3AED);

    final userService = UserService();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: FutureBuilder<UserModel?>(
            future: userService.getCurrentUserModel(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomLoadingIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar os dados.'));
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Usuário não encontrado.'));
              }

              final userModel = snapshot.data!;

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('uid', isEqualTo: userModel.uid)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CustomLoadingIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar os dados.'));
                  }
                  if (snapshot.hasData && !snapshot.data!.docs[0].exists) {
                    return const Center(
                        child: Text('Usuário não encontrado.'));
                  }

                  final data =
                      snapshot.data!.docs[0].data() as Map<String, dynamic>;
                  final updatedUserModel = UserModel.fromMap(data);
                  final hasPhoto = updatedUserModel.avatarUrl.isNotEmpty;
                  final initial = updatedUserModel.name.isNotEmpty
                      ? updatedUserModel.name[0].toUpperCase()
                      : '?';

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Perfil',
                          style: TextStyle(
                            fontFamily: 'RedHatDisplay',
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            letterSpacing: -0.5,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Gerencie sua conta e preferências',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: muted,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Card do usuário
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border:
                                Border.all(color: const Color(0xFFE8DFF8)),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withOpacity(0.06),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: hasPhoto
                                    ? () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => Scaffold(
                                              backgroundColor: Colors.black,
                                              appBar: AppBar(
                                                backgroundColor: Colors.black,
                                                foregroundColor: Colors.white,
                                                title: const Text('Minha foto'),
                                              ),
                                              body: Center(
                                                child: InteractiveViewer(
                                                  child: Image.network(
                                                    updatedUserModel.avatarUrl,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    : null,
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF9747FF),
                                        Color(0xFF6100FF),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF6100FF)
                                            .withOpacity(0.22),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(3),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          const Color(0xFFF3EBFF),
                                      backgroundImage: hasPhoto
                                          ? NetworkImage(
                                              updatedUserModel.avatarUrl)
                                          : null,
                                      child: hasPhoto
                                          ? null
                                          : Text(
                                              initial,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 34,
                                                fontWeight: FontWeight.w700,
                                                color: accent,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                updatedUserModel.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'RedHatDisplay',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  letterSpacing: -0.3,
                                  color: ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                updatedUserModel.email,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: muted,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F1FF),
                                  borderRadius: BorderRadius.circular(99),
                                  border: Border.all(
                                    color: const Color(0xFFE0D0FF),
                                  ),
                                ),
                                child: Text(
                                  updatedUserModel.locador
                                      ? 'Conta locador'
                                      : 'Conta locatário',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),
                        myText(text: 'Configurações'),
                        const SizedBox(height: 12),
                        MyRowsConfig(userModel: updatedUserModel),
                        const SizedBox(height: 22),
                        myText(text: 'Locação'),
                        const SizedBox(height: 12),
                        MyRow(
                          customKey: Keys.kProfileViewLocador,
                          text: userModel.locador
                              ? 'Quero deixar de ser um locador'
                              : 'Quero disponibilizar um espaço',
                          icon1: Image.asset(
                            'lib/assets/images/icon_disponibilizar.png',
                          ),
                          onTap: () => navigateBasedOnContract(context),
                        ),
                        const SizedBox(height: 22),
                        myText(text: 'Atendimento'),
                        const SizedBox(height: 12),
                        MyRow(
                          text: 'Central de ajuda',
                          icon1: Image.asset(
                            'lib/assets/images/icon_atendimento.png',
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CentralDeAjuda(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        myText(text: 'Jurídico'),
                        const SizedBox(height: 12),
                        MyRow(
                          text: 'Termos de serviço',
                          icon1: Image.asset(
                            'lib/assets/images/icon_termos.png',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ServiceTermsPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        MyRow(
                          text: 'Política de privacidade',
                          icon1: Image.asset(
                            'lib/assets/images/icon_privacidade.png',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PrivacyPolicyPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 22),
                        myText(text: 'Outros'),
                        const SizedBox(height: 12),
                        MyRow(
                          text: 'Sair do Festou',
                          icon1: Image.asset(
                            'lib/assets/images/icon_sair.png',
                          ),
                          onTap: () {
                            LogoutDialog.showExitConfirmationDialog(
                                context, ref);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget myText({required String text}) {
  return Text(
    text,
    style: const TextStyle(
      fontFamily: 'RedHatDisplay',
      fontSize: 16,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.2,
      color: Color(0xFF1C1426),
    ),
  );
}
