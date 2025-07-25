// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:escola_conducao/screens/auth/auth_screen.dart'; // Importe a nova AuthScreen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo à Maria Olga'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo_maria_olga.png',
                height: 150,
              ),
              const SizedBox(height: 30),
              Text(
                'Sua jornada para a carteira de condução começa aqui!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Navegar para a AuthScreen para escolha de login/registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                },
                child: const Text(
                    'Entrar/Registrar'), // Botão único para autenticação
              ),
            ],
          ),
        ),
      ),
    );
  }
}
