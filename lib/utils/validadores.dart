String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'O e-mail é obrigatório';
  }
  if (!value.contains('@')) {
    return 'O e-mail deve conter o caractere "@"';
  }
  if (!value.endsWith('.com') && !value.endsWith('.com.br')) {
    return 'O domínio deve terminar em .com ou .com.br';
  }
  return null;
}