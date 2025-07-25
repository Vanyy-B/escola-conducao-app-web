// lib/screens/auth/admin_login_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_conducao/screens/auth/admin_register_screen.dart';
import 'package:escola_conducao/screens/director/director_dashboard_screen.dart';
import 'package:escola_conducao/screens/secretary/secretary_dashboard_screen.dart';
import 'package:escola_conducao/screens/instructor/instructor_dashboard_screen.dart';
// import 'package:escola_conducao/screens/auth/auth_screen.dart'; // Removido: Unused import

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user != null) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          if (userDoc.exists) {
            final userRole = userDoc.get('role');
            if (userRole == null || userRole == 'pending') {
              setState(() {
                _errorMessage =
                    'Sua conta está pendente de aprovação. Aguarde o administrador definir seu papel.';
              });
              await FirebaseAuth.instance
                  .signOut(); // Desloga o usuário se o papel não está ativo
              return; // Impede a navegação
            }
            if (mounted) {
              _navigateToRoleScreen(userRole);
            }
          } else {
            setState(() {
              _errorMessage =
                  'Erro: Seus dados de usuário não foram encontrados. Por favor, entre em contato com o suporte.';
            });
            await FirebaseAuth.instance.signOut();
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = _getFirebaseErrorMessage(e.code);
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
        });
        debugPrint('Erro de login administrativo: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Nenhum usuário encontrado para este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-email':
        return 'O formato do e-mail é inválido.';
      case 'user-disabled':
        return 'Este usuário foi desativado.';
      default:
        return 'Erro de login. Verifique suas credenciais.';
    }
  }

  void _navigateToRoleScreen(String? role) {
    if (!mounted) return;
    Widget screen;
    switch (role) {
      case 'director':
        screen = const DirectorDashboardScreen();
        break;
      case 'secretary':
        screen = const SecretaryDashboardScreen();
        break;
      case 'instructor':
        screen = const InstructorDashboardScreen();
        break;
      default:
        FirebaseAuth.instance.signOut();
        setState(() {
          _errorMessage =
              'Seu papel não foi reconhecido. Tente novamente ou entre em contato com o suporte.';
        });
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Administrativo'),
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
                  'Acesso para Director, Secretário e Instrutor.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 40),
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
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Entrar'),
                      ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminRegisterScreen()),
                    );
                  },
                  child: const Text(
                      'Não tem uma conta administrativa? Crie uma aqui.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
