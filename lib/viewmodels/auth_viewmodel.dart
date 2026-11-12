import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  bool carregando = false;
  bool ocultarSenhaLogin = true;
  bool ocultarSenhaCadastro = true;
  
  String temaEscolhido = 'Claro';
  bool notificacoesAtivas = true;

  void alternarVisibilidadeSenhaLogin() {
    ocultarSenhaLogin = !ocultarSenhaLogin;
    notifyListeners();
  }

  void alternarVisibilidadeSenhaCadastro() {
    ocultarSenhaCadastro = !ocultarSenhaCadastro;
    notifyListeners();
  }

  void setTema(String tema, ValueNotifier<ThemeMode> temaNotifier) {
    temaEscolhido = tema;
    temaNotifier.value = (tema == 'Claro') ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setNotificacoes(bool valor) {
    notificacoesAtivas = valor;
    notifyListeners();
  }

  Future<Usuario?> fazerLogin(String email, String senha) async {
    carregando = true;
    notifyListeners();

    Usuario? usuario = await BancoDadosLocal.autenticar(email, senha);

    carregando = false;
    notifyListeners();
    return usuario;
  }

  Future<bool> realizarCadastro({
    required String nome,
    required String email,
    required String senha,
  }) async {
    carregando = true;
    notifyListeners();

    Usuario novoUsuario = Usuario(nome: nome, email: email, senha: senha);
    bool sucesso = await BancoDadosLocal.cadastrarUsuario(novoUsuario);

    if (sucesso) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('tema_app', temaEscolhido);
      await prefs.setBool('notificacoes', notificacoesAtivas);
    }

    carregando = false;
    notifyListeners();
    return sucesso;
  }
}