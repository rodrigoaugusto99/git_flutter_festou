class FormValidator {
  static String? validateName(String? value) {
    if (value?.isEmpty == true) {
      return 'Please enter your name';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value?.isEmpty == true) {
      return 'insira seu email';
    }
    if (!value!.contains('@')) {
      return 'formato invalido';
    }
    return null;
  }

  static String? validateBirthDate(String? value) {
    if (value?.isEmpty == true) {
      return 'insira sua data de nascimento';
    }
    // Adicione sua lógica de formatação e validação específica aqui
    // Exemplo: verificar se está no formato dd/mm/aaaa
    return null;
  }

  static String? validatePassword(String? value) {
    if (value?.isEmpty == true) {
      return 'insira sua senha';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value?.isEmpty == true) {
      return 'confirme sua senha';
    }
    if (value != password) {
      return 'as senhas precisam ser iguais';
    }
    return null;
  }
}
