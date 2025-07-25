// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_conducao/firebase_options.dart';
import 'package:escola_conducao/screens/auth/auth_screen.dart';
import 'package:escola_conducao/screens/director/director_dashboard_screen.dart';
import 'package:escola_conducao/screens/secretary/secretary_dashboard_screen.dart';
import 'package:escola_conducao/screens/instructor/instructor_dashboard_screen.dart';
import 'package:escola_conducao/screens/student/student_dashboard_screen.dart';
import 'package:escola_conducao/screens/loading_screen.dart'; // Importação do LoadingScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definindo as cores principais baseadas no flyer e na nova prioridade
    const Color primaryOrange =
        Color(0xFFFFAB00); // Laranja/Dourado vibrante como cor principal
    const Color secondaryGreen =
        Color(0xFF1B5E20); // Verde Escuro como cor secundária
    const Color accentPurple = Color(0xFF880E4F); // Roxo/Magenta de destaque
    const Color textColorOnDark = Colors.white;
    const Color textColorOnLight = Colors.black87;
    const Color lighterGrey =
        Color(0xFFEEEEEE); // Um cinza bem claro para fundos

    return MaterialApp(
      title: 'Escola de Condução',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Esquema de cores principal
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(
              primaryOrange), // Laranja/Dourado como primário
          accentColor:
              secondaryGreen, // Verde Escuro como accentColor (secundário)
        ).copyWith(
          primary: primaryOrange,
          onPrimary:
              textColorOnDark, // Cor do texto/ícones sobre a cor primária (Laranja)
          secondary: secondaryGreen,
          onSecondary:
              textColorOnDark, // Cor do texto/ícones sobre a cor secundária (Verde)
          surface: Colors
              .white, // Cor para superfícies de componentes como Cards, Dialogs
          background: lighterGrey, // Cor de fundo geral das telas
          error: Colors.red, // Cor para estados de erro
          onBackground: textColorOnLight, // Cor do texto sobre o fundo
          onSurface: textColorOnLight, // Cor do texto sobre superfícies
        ),

        scaffoldBackgroundColor: lighterGrey, // Fundo padrão para as telas

        appBarTheme: const AppBarTheme(
          backgroundColor: primaryOrange, // Cor do AppBar: Laranja/Dourado
          foregroundColor:
              textColorOnDark, // Cor dos ícones e texto no AppBar: Branco
          elevation: 4, // Sombra do AppBar
          titleTextStyle: TextStyle(
              color: textColorOnDark,
              fontSize: 20,
              fontWeight: FontWeight.bold),
          iconTheme:
              IconThemeData(color: textColorOnDark), // Ícones no AppBar brancos
        ),

        // TextTheme para estilos de texto globais
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 57, color: textColorOnLight),
          displayMedium: TextStyle(fontSize: 45, color: textColorOnLight),
          displaySmall: TextStyle(fontSize: 36, color: textColorOnLight),
          headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: primaryOrange), // Títulos grandes: Laranja
          headlineMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primaryOrange), // Títulos médios: Laranja
          headlineSmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryOrange), // Títulos de seção: Laranja
          titleLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColorOnLight), // Títulos de ListTile, etc.
          titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColorOnLight),
          titleSmall: TextStyle(fontSize: 14, color: textColorOnLight),
          bodyLarge: TextStyle(
              fontSize: 16, color: textColorOnLight), // Corpo do texto
          bodyMedium: TextStyle(
              fontSize: 14, color: Colors.black54), // Texto secundário
          bodySmall: TextStyle(fontSize: 12, color: Colors.black45),
          labelLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColorOnDark), // Estilo de texto para botões
          labelMedium: TextStyle(fontSize: 12, color: textColorOnLight),
          labelSmall: TextStyle(fontSize: 11, color: textColorOnLight),
        ),

        // ElevatedButtonTheme para botões elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor:
                textColorOnDark, // Cor do texto/ícone do botão: Branco
            backgroundColor:
                primaryOrange, // Cor de fundo do botão: Laranja/Dourado (Primário)
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Bordas mais arredondadas
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            elevation: 5, // Uma sombra mais proeminente
          ),
        ),

        // OutlinedButtonTheme para botões com borda
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor:
                secondaryGreen, // Cor do texto/ícone do botão: Verde Escuro
            side: const BorderSide(
                color: secondaryGreen, width: 2), // Borda verde
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        // TextButtonTheme para botões de texto
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                accentPurple, // Cor do texto/ícone do botão: Roxo/Magenta
          ),
        ),

        // Input Decoration Theme para campos de texto
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Bordas mais arredondadas
            borderSide: const BorderSide(
                color: primaryOrange, width: 1.5), // Borda primária (Laranja)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
                color: Colors.grey.shade400, width: 1), // Borda padrão
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
                color: primaryOrange,
                width: 2), // Borda focada: Laranja/Dourado
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                const BorderSide(color: Colors.red, width: 2), // Borda de erro
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
                color: Colors.red, width: 2), // Borda de erro focada
          ),
          filled: true,
          fillColor: Colors.white, // Preenchimento branco para contraste
          labelStyle: TextStyle(color: Colors.grey[700]), // Cor do label
          hintStyle: TextStyle(color: Colors.grey[500]), // Cor do hint
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        ),

        // Card Theme para cartões
        cardTheme: CardTheme(
          elevation: 6, // Sombra mais proeminente
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Mais arredondado
          ),
          color: Colors.white, // Fundo branco para cartões
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        ),

        // FloatingActionButton Theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryOrange, // Laranja/Dourado para FAB
          foregroundColor: textColorOnDark, // Texto/ícone branco
          elevation: 6,
        ),

        // Icon Theme (para ícones fora do AppBar)
        iconTheme: const IconThemeData(
          color: secondaryGreen, // Cor padrão para ícones: Verde Escuro
        ),

        // Dialog Theme
        dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
              color: primaryOrange,
              fontSize: 22,
              fontWeight: FontWeight.bold), // Título do diálogo: Laranja
          contentTextStyle:
              const TextStyle(color: textColorOnLight, fontSize: 16),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen(); // Mostra a tela de carregamento enquanto espera
          }
          if (userSnapshot.hasData) {
            final user = userSnapshot.data;
            if (user == null) {
              return const AuthScreen();
            }
            // Verifica o role do usuário no Firestore
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, firestoreSnapshot) {
                if (firestoreSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const LoadingScreen(); // Mostra a tela de carregamento
                }
                if (firestoreSnapshot.hasData &&
                    firestoreSnapshot.data!.exists) {
                  final userData =
                      firestoreSnapshot.data!.data() as Map<String, dynamic>;
                  final userRole = userData['role'];

                  switch (userRole) {
                    case 'director':
                      return const DirectorDashboardScreen();
                    case 'secretary':
                      return const SecretaryDashboardScreen();
                    case 'instructor':
                      return const InstructorDashboardScreen();
                    case 'student':
                      return const StudentDashboardScreen();
                    default:
                      // Caso o role seja desconhecido ou inválido, deslogue
                      FirebaseAuth.instance.signOut();
                      return const AuthScreen();
                  }
                }
                // Se o documento do usuário não existir no Firestore, deslogue
                FirebaseAuth.instance.signOut();
                return const AuthScreen();
              },
            );
          }
          // Nenhum usuário logado, mostra a tela de autenticação
          return const AuthScreen();
        },
      ),
    );
  }
}

// Função para criar um MaterialColor a partir de uma única cor
MaterialColor createMaterialColor(Color color) {
  List<double> strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red;
  final int g = color.green;
  final int b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
