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
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhlemxwaWt4Y3dhY3BienlydHNlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEwMDk0MTAsImV4cCI6MjA0NjU4NTQxMH0.xyA_AmkMEWX5Lau3pEcpyX8MIO-jIPtsXLnLpQ4Wqj4',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
