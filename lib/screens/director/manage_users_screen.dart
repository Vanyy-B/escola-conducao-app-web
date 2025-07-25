// lib/screens/director/manage_users_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_conducao/screens/director/user_detail_screen.dart'; // Para edição de usuários
import 'package:escola_conducao/screens/director/add_edit_course_screen.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  String _selectedRoleFilter = 'Todos';
  String _selectedStatusFilter = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  List<String> roles = [
    'Todos',
    'director',
    'secretary',
    'instructor',
    'student'
  ];
  List<String> statuses = [
    'Todos',
    'pending',
    'active',
    'inactive',
    'rejected'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      // Rebuild the UI to apply the search filter
    });
  }

  // Função para aprovar um usuário pendente
  Future<void> _approveUser(String userId, String requestedRole) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Aprovação'),
          content: Text(
              'Tem certeza que deseja aprovar este usuário como "$requestedRole"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({
                    'role': requestedRole,
                    'status': 'active',
                  });
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Usuário aprovado com sucesso!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao aprovar usuário: $e')),
                    );
                  }
                } finally {
                  if (context.mounted) {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  }
                }
              },
              child: const Text('Aprovar'),
            ),
          ],
        );
      },
    );
  }

  // Função para rejeitar um usuário pendente
  Future<void> _rejectUser(String userId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Rejeição'),
          content: const Text(
              'Tem certeza que deseja rejeitar este usuário? O status será alterado para "rejected".'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({
                    'status': 'rejected',
                    // O role pode permanecer o antigo ou ser limpo, dependendo da regra de negócio.
                    // Por enquanto, vamos manter o role anterior ou requestedRole para registro.
                  });
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Usuário rejeitado com sucesso!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao rejeitar usuário: $e')),
                    );
                  }
                } finally {
                  if (context.mounted) {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  }
                }
              },
              child:
                  const Text('Rejeitar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Função para ativar/desativar um usuário
  Future<void> _toggleUserStatus(String userId, String currentStatus) async {
    String newStatus = (currentStatus == 'active') ? 'inactive' : 'active';
    String actionWord = (currentStatus == 'active') ? 'desativar' : 'ativar';
    String actionPastParticiple =
        (currentStatus == 'active') ? 'desativado' : 'ativado';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar $actionWord Usuário'),
          content: Text('Tem certeza que deseja $actionWord este usuário?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({
                    'status': newStatus,
                  });
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Usuário $actionPastParticiple com sucesso!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Erro ao $actionWord usuário: $e')),
                    );
                  }
                } finally {
                  if (context.mounted) {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  }
                }
              },
              child: Text(actionWord == 'desativar' ? 'Desativar' : 'Ativar',
                  style: TextStyle(
                      color: actionWord == 'desativar'
                          ? Colors.red
                          : Colors.green)),
            ),
          ],
        );
      },
    );
  }

  // Função para excluir um usuário
  Future<void> _deleteUser(String userId, String userEmail) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text(
              'Tem certeza que deseja excluir o usuário "$userEmail"? Esta ação é irreversível.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Apenas remove o documento do Firestore.
                  // A exclusão da conta no Firebase Authentication é mais complexa e
                  // geralmente requer privilégios de administrador ou login recente do usuário.
                  // Para este projeto, focamos na remoção do documento de dados.
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .delete();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Usuário excluído com sucesso do Firestore!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao excluir usuário: $e')),
                    );
                  }
                } finally {
                  if (context.mounted) {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  }
                }
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerir Utilizadores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Pesquisar por Nome, E-mail, BI',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedRoleFilter,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por Papel',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                    items: roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role == 'Todos'
                            ? 'Todos os Papéis'
                            : role.replaceFirst(
                                role[0], role[0].toUpperCase())),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRoleFilter = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatusFilter,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por Status',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                    items: statuses.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status == 'Todos'
                            ? 'Todos os Status'
                            : status.replaceFirst(
                                status[0], status[0].toUpperCase())),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatusFilter = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Removida a verificação !snapshot.hasData || snapshot.data!.docs.isEmpty aqui.
                  // Agora, assumimos que se não está waiting, tem data ou um erro que será tratado abaixo.
                  if (snapshot.hasError) {
                    print(
                        'DEBUG: Erro no StreamBuilder: ${snapshot.error}'); // DEBUG PRINT
                    return Center(
                        child: Text(
                            'Erro ao carregar utilizadores: ${snapshot.error}'));
                  }

                  // Se houver dados, procede com a filtragem
                  final allUsers = snapshot.data!.docs;
                  print(
                      'DEBUG: Total de utilizadores buscados do Firestore: ${allUsers.length}'); // DEBUG PRINT

                  final filteredUsers = allUsers.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name']?.toLowerCase() ?? '';
                    final email = data['email']?.toLowerCase() ?? '';
                    final bi = data['bi']?.toLowerCase() ?? '';

                    final actualRole = data['role']?.toLowerCase() ?? '';
                    final requestedRole =
                        data['requestedRole']?.toLowerCase() ?? '';
                    final userEffectiveRole =
                        actualRole.isNotEmpty ? actualRole : requestedRole;

                    final status = data['status']?.toLowerCase() ?? '';
                    final searchText = _searchController.text.toLowerCase();

                    final matchesSearch = searchText.isEmpty ||
                        name.contains(searchText) ||
                        email.contains(searchText) ||
                        bi.contains(searchText);

                    final matchesRole = _selectedRoleFilter == 'Todos' ||
                        userEffectiveRole == _selectedRoleFilter;

                    final matchesStatus = _selectedStatusFilter == 'Todos' ||
                        status == _selectedStatusFilter;

                    print('--- DEBUG DETALHADO DE FILTRAGEM ---');
                    print('Usuário: $name ($email)');
                    print(
                        'Dados brutos: Role=$actualRole, RequestedRole=$requestedRole, Status=$status');
                    print('Papel Efetivo para Filtragem: $userEffectiveRole');
                    print(
                        'Filtro de Papel Selecionado: $_selectedRoleFilter (Corresponde: $matchesRole)');
                    print(
                        'Filtro de Status Selecionado: $_selectedStatusFilter (Corresponde: $matchesStatus)');
                    print(
                        'Texto de Pesquisa: "$searchText" (Corresponde: $matchesSearch)');
                    print(
                        'RESULTADO FINAL DA FILTRAGEM: ${matchesSearch && matchesRole && matchesStatus}');
                    print('------------------------------------');

                    return matchesSearch && matchesRole && matchesStatus;
                  }).toList();

                  print(
                      'DEBUG: Contagem de utilizadores filtrados: ${filteredUsers.length}'); // DEBUG PRINT

                  if (filteredUsers.isEmpty) {
                    return const Center(
                        child:
                            Text('Nenhum utilizador corresponde aos filtros.'));
                  }

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final userDoc = filteredUsers[index];
                      final userData = userDoc.data() as Map<String, dynamic>;
                      final userId = userDoc.id;
                      final userName = userData['name'] ?? 'Nome Desconhecido';
                      final userEmail =
                          userData['email'] ?? 'E-mail Desconhecido';
                      final userRole = userData['role'] ?? 'Não Atribuído';
                      final userRequestedRole =
                          userData['requestedRole'] ?? 'Nenhum';
                      final userStatus = userData['status'] ?? 'desconhecido';

                      Color statusColor;
                      switch (userStatus) {
                        case 'pending':
                          statusColor = Colors.orange;
                          break;
                        case 'active':
                          statusColor = Colors.green;
                          break;
                        case 'inactive':
                          statusColor = Colors.red;
                          break;
                        case 'rejected':
                          statusColor = Colors.grey;
                          break;
                        default:
                          statusColor = Colors.black;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userEmail,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Papel: ${userRole.replaceFirst(userRole[0], userRole[0].toUpperCase())}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  if (userRequestedRole != 'Nenhum' &&
                                      userRequestedRole != userRole)
                                    Text(
                                      ' (Solicitado: ${userRequestedRole.replaceFirst(userRequestedRole[0], userRequestedRole[0].toUpperCase())})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              fontStyle: FontStyle.italic),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('Status: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Text(
                                    userStatus.replaceFirst(userStatus[0],
                                        userStatus[0].toUpperCase()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing:
                                    8.0, // Espaço horizontal entre os botões
                                runSpacing:
                                    4.0, // Espaço vertical entre as linhas de botões
                                children: [
                                  // Botão Editar
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserDetailScreen(userId: userId),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit, size: 18),
                                    label: const Text('Editar'),
                                  ),
                                  // Botões de Aprovar/Rejeitar para status 'pending'
                                  if (userStatus == 'pending') ...[
                                    ElevatedButton.icon(
                                      onPressed: () => _approveUser(
                                          userId, userRequestedRole),
                                      icon: const Icon(Icons.check, size: 18),
                                      label: const Text('Aprovar'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => _rejectUser(userId),
                                      icon: const Icon(Icons.close, size: 18),
                                      label: const Text('Rejeitar'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                    ),
                                  ],
                                  // Botões de Ativar/Desativar para status 'active' ou 'inactive'
                                  if (userStatus == 'active' ||
                                      userStatus == 'inactive')
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          _toggleUserStatus(userId, userStatus),
                                      icon: Icon(
                                          userStatus == 'active'
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 18),
                                      label: Text(userStatus == 'active'
                                          ? 'Desativar'
                                          : 'Ativar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: userStatus == 'active'
                                            ? Colors.orange
                                            : Colors.blue,
                                      ),
                                    ),
                                  // Botão Excluir (disponível para todos, mas com confirmação)
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _deleteUser(userId, userEmail),
                                    icon: const Icon(Icons.delete, size: 18),
                                    label: const Text('Excluir'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
