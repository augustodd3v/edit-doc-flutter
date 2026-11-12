import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/validadores.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authViewModel = AuthViewModel();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _authViewModel.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (_formKey.currentState!.validate()) {
      final usuario = await _authViewModel.fazerLogin(
        _emailController.text.trim(),
        _senhaController.text,
      );

      if (!mounted) return;

      if (usuario != null) {
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: usuario.nome,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail ou senha incorretos!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _authViewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    validator: validarEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _authViewModel.ocultarSenhaLogin
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _authViewModel.alternarVisibilidadeSenhaLogin,
                      ),
                    ),
                    obscureText: _authViewModel.ocultarSenhaLogin,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe a senha' : null,
                  ),
                  const SizedBox(height: 24),
                  _authViewModel.carregando
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _entrar,
                          child: const Text('Entrar'),
                        ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                    child: const Text('Não tem conta? Cadastre-se'),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}