// lib/screens/auth/admin_register_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:escola_conducao/screens/auth/admin_login_screen.dart'; // Removido: Unused import

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _biController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  bool _isLoading = false;
  String? _errorMessage;
  bool _registrationSuccess = false;

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

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        setState(() {
          _errorMessage = 'Por favor, selecione seu papel.';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _registrationSuccess = false;
      });
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': _nameController.text.trim(),
            'phone': _phoneController.text.trim(),
            'bi': _biController.text.trim(),
            'email': _emailController.text.trim(),
            'requestedRole': _selectedRole,
            'role': null, // Papel inicial nulo, aguardando definição do admin
            'status': 'pending', // Status da conta
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        if (mounted) {
          setState(() {
            _registrationSuccess = true;
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = _getFirebaseErrorMessage(e.code);
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
        });
        debugPrint('Erro de registro administrativo: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Este e-mail já está em uso.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'invalid-email':
        return 'O formato do e-mail é inválido.';
      default:
        return 'Erro de registro. Tente novamente.';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _biController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta Administrativa'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Preencha seus dados para criar sua conta administrativa:',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo',
                    prefixIcon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome completo.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone (ex: 9XX XXX XXX)',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu telefone.';
                    }
                    if (value.length < 9) {
                      return 'Telefone inválido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _biController,
                  decoration: const InputDecoration(
                    labelText: 'Número do Bilhete de Identidade (BI)',
                    hintText: 'Ex: 12345678LA1',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.text,
                  validator: _validateBIAngolano,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail.';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'E-mail inválido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha.';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    if (value.length > 8) {
                      return 'A senha não deve exceder 8 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  hint: const Text('Selecione seu papel'),
                  decoration: const InputDecoration(
                    labelText: 'Papel',
                    prefixIcon: Icon(Icons.work),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'director', child: Text('Director')),
                    DropdownMenuItem(
                        value: 'secretary', child: Text('Secretário(a)')),
                    DropdownMenuItem(
                        value: 'instructor', child: Text('Instrutor(a)')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue;
                      _errorMessage = null;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione um papel.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_registrationSuccess)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'A sua conta foi criada com sucesso! Estamos a verificar o seu papel, aguarde até que o administrador defina o seu papel no sistema para ter acesso.',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _register,
                        child: const Text('Criar Conta Administrativa'),
                      ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Já tem uma conta? Faça login aqui.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
