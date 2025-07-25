// lib/screens/director/director_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:escola_conducao/screens/auth/auth_screen.dart'; // Para o logout
import 'package:escola_conducao/screens/director/manage_users_screen.dart'; // Para gerenciar usuários
import 'package:escola_conducao/screens/director/reports_screen.dart'; // Para relatórios
import 'package:escola_conducao/screens/director/manage_content_screen.dart'; // Para gerenciar conteúdos
// Telas futuras que o Director pode navegar
import 'package:escola_conducao/screens/director/manage_courses_screen.dart'; // Criaremos esta tela
import 'package:escola_conducao/screens/director/financial_management_screen.dart'; // Criaremos esta tela

class DirectorDashboardScreen extends StatelessWidget {
  // Atenção: o nome da classe é DirectorDashboardScreen
  const DirectorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard do Director'),
        // LINHA MELHORADA: Remove a seta de voltar no AppBar
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Terminar Sessão',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                // Redireciona para a tela de autenticação após o logout
                Navigator.of(context).pushAndRemoveUntil(
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
              'Bem-vindo, Director!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 colunas
                crossAxisSpacing: 16.0, // Espaçamento horizontal
                mainAxisSpacing: 16.0, // Espaçamento vertical
                children: <Widget>[
                  _buildDashboardCard(
                    context,
                    icon: Icons.people,
                    title: 'Gerir Utilizadores',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageUsersScreen()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.menu_book,
                    title: 'Gerir Cursos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageCoursesScreen()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.bar_chart,
                    title: 'Relatórios',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportsScreen()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.attach_money,
                    title: 'Gestão Financeira',
                    onTap: () {
                      // TODO: Navegar para a tela de gestão financeira
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const FinancialManagementScreen()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.library_books, // Ícone para conteúdo
                    title: 'Gestão de Conteúdos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageContentScreen()),
                      );
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
            Icon(icon,
                size: 50,
                color: Theme.of(context)
                    .colorScheme
                    .primary), // Usa a cor primária do tema
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
