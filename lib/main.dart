import 'package:flutter/material.dart';
import 'package:hackathon/Screens/welcomeScreen.dart';
import 'package:hackathon/widgets/bottomNavigator.dart';
import 'Screens/scanScreen.dart';
import 'Screens/loginScreen.dart';
import 'Screens/cadastroScreen.dart';
import 'Screens/historicoScreen.dart';
import 'Screens/confirmacaoScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xezlpikxcwacpbzyrtse.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhlemxwaWt4Y3dhY3BienlydHNlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEwMDk0MTAsImV4cCI6MjA0NjU4NTQxMH0.xyA_AmkMEWX5Lau3pEcpyX8MIO-jIPtsXLnLpQ4Wqj4',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,  // Desativa a faixa de debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/welcomeScreen',
      routes: {
        '/welcomeScreen': (context) => WelcomeScreen(),
        '/tela_login': (context) => LoginScreen(),
        '/tela_cadastro': (context) => CadastroScreen(),
        '/tela_scan': (context) => ScanScreen(),
        '/tela_historico': (context) => HistoricoScreen(),
        '/tela_confirmacao': (context) => ConfirmacaoScreen(),
        '/home': (context) => Scaffold(
          body: ScanScreen(),
          bottomNavigationBar: HomeScreen(),
        ),
      },
    );
  }
}
