// lib/screens/secretary/manage_payments_screen.dart
import 'package:flutter/material.dart';

class ManagePaymentsScreen extends StatelessWidget {
  const ManagePaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Pagamentos'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Esta é a tela de Gestão de Pagamentos.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Icon(Icons.payment, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Aqui a secretária poderá registar e acompanhar os pagamentos dos alunos.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Registrar Novo Pagamento Clicado');
                  // TODO: Implementar registro de pagamento
                },
                child: const Text('Registrar Novo Pagamento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
