String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Insira um email';
  }

  // Regex para validar o formato do email
  RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  if (!emailRegExp.hasMatch(value)) {
    return 'Email inválido';
  }

  return null; // Email válido
}

class Validators {
  static String? cnpj(String? cnpj, {String? customMessage}) {
    if (cnpj == null || cnpj.isEmpty) {
      if (customMessage != null) {
        return customMessage;
      }
      return 'Insira seu CNPJ';
    }

    // Remove qualquer caractere que não seja número
    cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se o CNPJ tem 14 dígitos ou se é uma sequência de números repetidos
    if (cnpj.length != 14 || RegExp(r'^(\d)\1*$').hasMatch(cnpj)) {
      return 'CNPJ inválido';
    }

    // Calcula o primeiro dígito verificador
    int sum = 0;
    List<int> weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    for (int i = 0; i < 12; i++) {
      sum += int.parse(cnpj[i]) * weights1[i];
    }
    int firstVerifier = sum % 11;
    firstVerifier = firstVerifier < 2 ? 0 : 11 - firstVerifier;

    // Calcula o segundo dígito verificador
    sum = 0;
    List<int> weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    for (int i = 0; i < 13; i++) {
      sum += int.parse(cnpj[i]) * weights2[i];
    }
    int secondVerifier = sum % 11;
    secondVerifier = secondVerifier < 2 ? 0 : 11 - secondVerifier;

    // Verifica se os dígitos verificadores são iguais aos informados
    if (firstVerifier == int.parse(cnpj[12]) &&
        secondVerifier == int.parse(cnpj[13])) {
      return null;
    }
    return 'CNPJ inválido';
  }

  static String? cpf(String? cpf, {String? customMessage}) {
    if (cpf == null || cpf.isEmpty) {
      if (customMessage != null) {
        return customMessage;
      }
      return 'Insira seu CPF';
    }
    // Remove qualquer caractere que não seja número
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se o CPF tem 11 dígitos ou se é uma sequência de números repetidos
    if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Calcula o primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int firstVerifier = sum % 11;
    firstVerifier = firstVerifier < 2 ? 0 : 11 - firstVerifier;

    // Calcula o segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int secondVerifier = sum % 11;
    secondVerifier = secondVerifier < 2 ? 0 : 11 - secondVerifier;

    // Verifica se os dígitos verificadores são iguais aos informados
    if (firstVerifier == int.parse(cpf[9]) &&
        secondVerifier == int.parse(cpf[10])) {
      return null;
    }
    return 'CPF inválido';
  }
}
