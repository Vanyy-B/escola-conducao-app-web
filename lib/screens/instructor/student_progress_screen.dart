// lib/screens/instructor/student_progress_screen.dart
import 'package:flutter/material.dart';

class StudentProgressScreen extends StatelessWidget {
  const StudentProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progresso dos Alunos'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Esta é a tela de acompanhamento do progresso dos alunos.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Icon(Icons.people_alt, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Aqui você poderá visualizar o desempenho dos seus alunos em aulas e testes.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Ver Lista de Alunos Clicado');
                  // TODO: Implementar lista de alunos e seu progresso
                },
                child: const Text('Ver Lista de Alunos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
