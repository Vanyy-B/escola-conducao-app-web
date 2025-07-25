// lib/screens/director/user_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;
  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole;
  String? _selectedStatus;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _biController;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _biController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _biController.text = data['bi'] ?? '';

        // --- INÍCIO DA CORREÇÃO APLICADA AQUI ---
        final String? fetchedRole = data['role'] ?? data['requestedRole'];
        if (['student', 'director', 'secretary', 'instructor']
            .contains(fetchedRole)) {
          _selectedRole = fetchedRole;
        } else {
          _selectedRole =
              'student'; // Define um papel padrão se for inválido/nulo
        }
        // --- FIM DA CORREÇÃO APLICADA AQUI ---

        _selectedStatus = data['status'] ?? 'pending';
      } else {
        _errorMessage = 'Utilizador não encontrado.';
      }
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados do utilizador: $e';
      debugPrint('Erro ao carregar dados do utilizador: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'bi': _biController.text.trim(),
          'role': _selectedRole,
          'status': _selectedStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Dados do utilizador atualizados com sucesso!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Erro ao atualizar utilizador: $e';
        });
        debugPrint('Erro ao atualizar utilizador: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateBIAngolano(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o número do seu BI.';
    }
    final biRegex = RegExp(r'^\d{8,10}[A-Z]{2}\d{1}$');
    if (!biRegex.hasMatch(value)) {
      return 'Formato do BI inválido (ex: 12345678LA1).';
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _biController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Utilizador'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Nome Completo'),
                          validator: (value) => value!.isEmpty
                              ? 'O nome não pode ser vazio.'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _emailController,
                          decoration:
                              const InputDecoration(labelText: 'E-mail'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'E-mail não pode ser vazio.';
                            }
                            if (!value.contains('@')) {
                              return 'E-mail inválido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _phoneController,
                          decoration:
                              const InputDecoration(labelText: 'Telefone'),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value!.isEmpty
                              ? 'O telefone não pode ser vazio.'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _biController,
                          decoration: const InputDecoration(
                              labelText: 'Bilhete de Identidade (BI)'),
                          validator: _validateBIAngolano,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: const InputDecoration(
                              labelText: 'Papel do Utilizador'),
                          items: const [
                            DropdownMenuItem(
                                value: 'student', child: Text('Aluno')),
                            DropdownMenuItem(
                                value: 'director', child: Text('Director')),
                            DropdownMenuItem(
                                value: 'secretary',
                                child: Text('Secretário(a)')),
                            DropdownMenuItem(
                                value: 'instructor',
                                child: Text('Instrutor(a)')),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRole = newValue;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Selecione um papel.' : null,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: const InputDecoration(
                              labelText: 'Status da Conta'),
                          items: const [
                            DropdownMenuItem(
                                value: 'active', child: Text('Ativo')),
                            DropdownMenuItem(
                                value: 'pending', child: Text('Pendente')),
                            DropdownMenuItem(
                                value: 'disabled', child: Text('Desativado')),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedStatus = newValue;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Selecione um status.' : null,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _updateUser,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Atualizar Utilizador'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
