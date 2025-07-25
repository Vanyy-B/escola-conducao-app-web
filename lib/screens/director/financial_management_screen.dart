// lib/screens/director/financial_management_screen.dart
import 'package:flutter/material.dart';

class FinancialManagementScreen extends StatelessWidget {
  const FinancialManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão Financeira'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Esta é a tela de Gestão Financeira.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Icon(Icons.attach_money,
                  size: 100,
                  color: Theme.of(context)
                      .colorScheme
                      .primary), // Usa a cor primária do tema
              const SizedBox(height: 20),
              Text(
                'Aqui você poderá monitorar pagamentos, despesas e a saúde financeira da escola.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Ver Balanço Clicado');
                  // TODO: Implementar visualização do balanço
                },
                child: const Text('Ver Balanço Financeiro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
