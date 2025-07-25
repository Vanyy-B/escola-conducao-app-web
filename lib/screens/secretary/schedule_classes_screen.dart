// lib/screens/secretary/schedule_classes_screen.dart
import 'package:flutter/material.dart';

class ScheduleClassesScreen extends StatelessWidget {
  const ScheduleClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Aulas'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Esta é a tela de Agendamento de Aulas.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Icon(Icons.calendar_today, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Aqui a secretária poderá agendar e gerir as aulas teóricas e práticas.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Abrir Calendário de Aulas Clicado');
                  // TODO: Implementar calendário de agendamento
                },
                child: const Text('Abrir Calendário de Aulas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
