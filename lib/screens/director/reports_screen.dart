// lib/screens/director/reports_screen.dart
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Esta é a tela de Relatórios.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Icon(Icons.analytics,
                  size: 100,
                  color: Theme.of(context)
                      .colorScheme
                      .primary), // Usa a cor primária do tema
              const SizedBox(height: 20),
              Text(
                'Aqui você poderá gerar diversos relatórios sobre alunos, instrutores, finanças, etc.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implementar geração de um relatório de exemplo
                  debugPrint('Gerar Relatório de Alunos Clicado');
                },
                child: const Text('Gerar Relatório de Alunos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
