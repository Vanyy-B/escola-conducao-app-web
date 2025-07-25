// lib/screens/secretary/register_student_screen.dart
import 'package:flutter/material.dart';

class RegisterStudentScreen extends StatelessWidget {
  const RegisterStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Novo Aluno'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Esta é a tela de Registro de Alunos.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Icon(Icons.person_add, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Aqui a secretária poderá registrar novos alunos no sistema.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Formulário de Registro de Aluno Clicado');
                  // TODO: Implementar formulário de registro
                },
                child: const Text('Abrir Formulário de Registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
