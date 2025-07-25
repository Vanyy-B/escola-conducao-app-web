// lib/screens/instructor/report_issues_screen.dart
import 'package:flutter/material.dart';

class ReportIssuesScreen extends StatelessWidget {
  const ReportIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Problemas'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Esta é a tela para reportar problemas ou incidentes.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Icon(Icons.warning, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Use esta seção para informar sobre quaisquer problemas com veículos, alunos ou aulas.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Abrir Formulário de Relato Clicado');
                  // TODO: Implementar formulário de relato de problemas
                },
                child: const Text('Abrir Formulário de Relato'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
