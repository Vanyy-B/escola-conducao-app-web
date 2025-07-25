// lib/screens/instructor/my_classes_screen.dart
import 'package:flutter/material.dart';

class MyClassesScreen extends StatelessWidget {
  const MyClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Aulas'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Esta é a tela das suas aulas agendadas.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Icon(Icons.calendar_month, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Aqui você poderá ver o seu cronograma de aulas teóricas e práticas.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Ver Cronograma Clicado');
                  // TODO: Implementar visualização do cronograma de aulas
                },
                child: const Text('Ver Cronograma'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
