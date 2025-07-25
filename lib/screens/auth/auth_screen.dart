// lib/screens/auth/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:escola_conducao/screens/auth/student_login_screen.dart';
import 'package:escola_conducao/screens/auth/admin_login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar ou Registrar'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Escolha o tipo de acesso:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentLoginScreen()),
                    );
                  },
                  child: const Text('Acesso de Aluno'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminLoginScreen()),
                    );
                  },
                  child: const Text('Acesso Administrativo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
