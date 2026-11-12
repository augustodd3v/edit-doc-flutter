import 'package:flutter/material.dart';
import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';
import '../main.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  Future<void> _mostrarPreferencias(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final tema = prefs.getString('tema_app') ?? 'Não definido';
    final notificacoes = prefs.getBool('notificacoes') ?? false;

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Suas Preferências'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tema selecionado: $tema'),
              const SizedBox(height: 8),
              Text('Notificações: ${notificacoes ? "Ativadas" : "Desativadas"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Fechar'),
            )
          ],
        ),
      );
    }
  }

  Future<void> _mostrarUsuarios(BuildContext context) async {
    final usuarios = await BancoDadosLocal.obterTodosUsuarios();

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Usuários Cadastrados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final u = usuarios[index];
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(u.nome),
                        subtitle: Text(u.email),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String nomeUsuario = ModalRoute.of(context)!.settings.arguments as String? ?? 'Usuário';

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $nomeUsuario!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              temaNotifier.value = ThemeMode.light;
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => _mostrarPreferencias(context),
              child: const Card(
                elevation: 4,
                child: ListTile(
                  leading: Icon(Icons.settings, size: 40, color: Colors.blue),
                  title: Text('Ver Preferências'),
                  subtitle: Text('Toque para exibir as configurações salvas no SharedPreferences'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _mostrarUsuarios(context),
              child: const Card(
                elevation: 4,
                child: ListTile(
                  leading: Icon(Icons.storage, size: 40, color: Colors.green),
                  title: Text('Ver Banco de Dados'),
                  subtitle: Text('Toque para listar os usuários salvos no Banco Local'),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Desenvolvido por: Mendell Kalyl',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}