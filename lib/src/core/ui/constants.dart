import 'package:flutter/material.dart';

sealed class ColorsConstants {
  static const purple = Color.fromARGB(255, 163, 63, 196);
  static const grey = Color.fromARGB(255, 223, 224, 214);
  static const greyLight = Color(0xFFE6E2E9);
  static const blue = Color.fromARGB(255, 38, 157, 201);
}

/*sealed class FontConstants {
  static const fontFamily = GoogleFonts.roboto;
}*/

sealed class ImageConstants {
  static const loginBackground = 'lib/assets/images/background_login.png';
  static const gliterBlackground = 'lib/assets/images/gliter.jpeg';
  static const ballsBackground = 'lib/assets/images/balls.jpeg';
  static const avatar = 'lib/assets/images/avatar.png';
  static const festouLogo = 'lib/assets/images/logo_festou.png';
  static const festouLogo2 = 'lib/assets/images/festou-logo.png';
  static const googleLogo = 'lib/assets/images/google.png';
}

sealed class TextConstants {
  static const welcomeLogin = 'Welcome back you\'ve been missed!';
  static const notMemberLogin = 'Not a member?';
  static const orContinueWith = 'Or continue with';
  static const letsCreateAccount = 'Lts create your account!';
  static const alreadyHaveAccount = 'Already have an account?';
}

sealed class ListConstants {
  static const availableServices = [
    'Cozinha',
    'Garçons',
    'Decoração',
    'Som e Iluminação',
    'Estacionamento',
    'Banheiros',
    'Segurança',
    'Ar-condicionado',
    'Limpeza ',
    'Bar',
  ];

  static const availableTypes = [
    'Casa',
    'Apartmaentio',
    'Salao',
    'chacara',
    'playground baby',
  ];
}
