// lib/screens/secretary/manage_documents_screen.dart
import 'package:flutter/material.dart';

class ManageDocumentsScreen extends StatelessWidget {
  const ManageDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Documentos'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Esta é a tela de Gestão de Documentos.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Icon(Icons.folder_open, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Aqui a secretária poderá organizar e aceder aos documentos dos alunos e da escola.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Ver Documentos Clicado');
                  // TODO: Implementar visualização/upload de documentos
                },
                child: const Text('Ver Documentos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
