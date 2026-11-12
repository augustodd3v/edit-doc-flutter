import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';

final ValueNotifier<ThemeMode> temaNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'App Persistência',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const TelaLogin(),
            '/cadastro': (context) => const TelaCadastro(),
            '/home': (context) => const TelaHome(),
          },
        );
      },
    );
  }
}