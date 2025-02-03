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
