// lib/screens/secretary/secretary_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:escola_conducao/screens/auth/auth_screen.dart'; // Para o logout

class SecretaryDashboardScreen extends StatelessWidget {
  const SecretaryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard do Secretário(a)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Terminar Sessão',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Bem-vindo, Secretário(a)!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: <Widget>[
                  _buildDashboardCard(
                    context,
                    icon: Icons.person_add,
                    title: 'Registrar Aluno',
                    onTap: () {
                      debugPrint('Registrar Aluno Clicado');
                      // TODO: Navegar para tela de registro de aluno (se necessário uma versão interna)
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Agendar Aulas',
                    onTap: () {
                      debugPrint('Agendar Aulas Clicado');
                      // TODO: Navegar para tela de agendamento de aulas
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.payment,
                    title: 'Gestão de Pagamentos',
                    onTap: () {
                      debugPrint('Gestão de Pagamentos Clicado');
                      // TODO: Navegar para tela de gestão de pagamentos
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.folder,
                    title: 'Gestão de Documentos',
                    onTap: () {
                      debugPrint('Gestão de Documentos Clicado');
                      // TODO: Navegar para tela de gestão de documentos
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
