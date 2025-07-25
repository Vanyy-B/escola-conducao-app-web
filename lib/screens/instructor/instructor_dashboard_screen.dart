// lib/screens/instructor/instructor_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:escola_conducao/screens/auth/auth_screen.dart'; // Para o logout

// Telas futuras que o Instrutor(a) pode navegar (placeholders por enquanto)
import 'package:escola_conducao/screens/instructor/my_classes_screen.dart'; // NEW: Criaremos esta tela
import 'package:escola_conducao/screens/instructor/student_progress_screen.dart'; // NEW: Criaremos esta tela
import 'package:escola_conducao/screens/instructor/report_issues_screen.dart'; // NEW: Criaremos esta tela

class InstructorDashboardScreen extends StatelessWidget {
  const InstructorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard do Instrutor(a)'),
        // Remove a seta de voltar no AppBar
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Terminar Sessão',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                // Redireciona para a tela de escolha de login, removendo todas as rotas anteriores
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
              'Bem-vindo, Instrutor(a)!',
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
                    icon: Icons.calendar_today,
                    title: 'Minhas Aulas',
                    onTap: () {
                      // TODO: Navegar para a tela de minhas aulas
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyClassesScreen()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.bar_chart,
                    title: 'Progresso dos Alunos',
                    onTap: () {
                      // TODO: Navegar para a tela de progresso dos alunos
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const StudentProgressScreen()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.report_problem,
                    title: 'Reportar Problemas',
                    onTap: () {
                      // TODO: Navegar para a tela de reportar problemas
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportIssuesScreen()),
                      );
                    },
                  ),
                  // Adicione mais cards conforme necessário para funcionalidades do instrutor
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
