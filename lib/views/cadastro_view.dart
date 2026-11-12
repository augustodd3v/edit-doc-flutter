import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/validadores.dart';
import '../main.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authViewModel = AuthViewModel();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _authViewModel.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      bool sucesso = await _authViewModel.realizarCadastro(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );

      if (!mounted) return;

      if (!sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este e-mail já está cadastrado!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _authViewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Novo Cadastro')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dados Pessoais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome Completo', border: OutlineInputBorder()),
                    validator: (value) => value == null || value.isEmpty ? 'Informe seu nome' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
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
                          _authViewModel.ocultarSenhaCadastro
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _authViewModel.alternarVisibilidadeSenhaCadastro,
                      ),
                    ),
                    obscureText: _authViewModel.ocultarSenhaCadastro,
                    validator: (value) => value == null || value.length < 6 ? 'A senha deve ter min. 6 caracteres' : null,
                  ),
                  const SizedBox(height: 24),
                  const Text('Preferências do Aplicativo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Tema da Interface:'),
                  RadioListTile<String>(
                    title: const Text('Tema Claro'),
                    value: 'Claro',
                    groupValue: _authViewModel.temaEscolhido,
                    onChanged: (val) => _authViewModel.setTema(val!, temaNotifier),
                  ),
                  RadioListTile<String>(
                    title: const Text('Tema Escuro'),
                    value: 'Escuro',
                    groupValue: _authViewModel.temaEscolhido,
                    onChanged: (val) => _authViewModel.setTema(val!, temaNotifier),
                  ),
                  SwitchListTile(
                    title: const Text('Receber Notificações Push'),
                    subtitle: const Text('Novidades e alertas da conta'),
                    value: _authViewModel.notificacoesAtivas,
                    onChanged: _authViewModel.setNotificacoes,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _authViewModel.carregando
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _cadastrar,
                            child: const Text('Cadastrar e Salvar Preferências', style: TextStyle(fontSize: 16)),
                          ),
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