// lib/screens/student/student_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:escola_conducao/screens/auth/auth_screen.dart'; // Para o logout

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard do Aluno'),
        // **ADICIONE/VERIFIQUE ESTA LINHA:**
        automaticallyImplyLeading: false,
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
              'Bem-vindo, Aluno!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            // Cartão de Resumo do Progresso
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seu Progresso',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    // Adicionando 'const' aos construtores dos ListTile e LinearProgressIndicator
                    const ListTile(
                      leading: Icon(Icons.book, color: Colors.blueAccent),
                      title: Text('Aulas Teóricas Completas: 10/12'),
                      subtitle: LinearProgressIndicator(
                          value: 10 / 12, color: Colors.blueAccent),
                    ),
                    const ListTile(
                      leading: Icon(Icons.car_rental, color: Colors.green),
                      title: Text('Aulas Práticas Completas: 5/20'),
                      subtitle: LinearProgressIndicator(
                          value: 5 / 20, color: Colors.green),
                    ),
                    const ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.purple),
                      title: Text('Testes Teóricos Aprovados: 2/3'),
                      subtitle: LinearProgressIndicator(
                          value: 2 / 3, color: Colors.purple),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Seção de Próximas Aulas
            Text('Próximas Aulas',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Aula Prática - Dia 25/07/2025 às 10:00'),
                      subtitle: Text(
                          'Instrutor: João Silva | Local: Pista de Treino'),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Aula Teórica - Dia 26/07/2025 às 14:00'),
                      subtitle: Text('Tema: Primeiros Socorros | Sala: B'),
                    ),
                  ),
                  // Adicionar mais aulas aqui...
                ],
              ),
            ),
            // Botões de Ação Rápida
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navegar para tela de agendamento
                    debugPrint('Agendar Aula');
                  },
                  icon: const Icon(Icons.schedule),
                  label: const Text('Agendar Aula'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navegar para tela de pagamentos
                    debugPrint('Ver Pagamentos');
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Pagamentos'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
