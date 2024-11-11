import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({Key? key}) : super(key: key);

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> registrarUsuario() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = emailController.text;
      final password = passwordController.text;
      final nome = nameController.text;

      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Armazene informações adicionais no Supabase
        await Supabase.instance.client
            .from('usuarios')
            .insert({'id': response.user!.id, 'nome-completo': nome, 'email': email, 'senha': password});

        Navigator.pushNamed(context, '/tela_login');
      } else {
        // Exibe um diálogo de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar usuário')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF105D44),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Título do App
              const Column(
                children: [
                  Text(
                    "Recollet",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text("By Banco do Brasil", style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 40),

              // Formulário de Registro
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de Nome
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 20),
                    // Campo de Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Campo de Senha
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
                      ),
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                    ),
                    const SizedBox(height: 20),
                    // Campo de Confirmar Senha
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirmar senha',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
                      ),
                      obscureText: true,
                      validator: (value) => value != passwordController.text ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: 30),
                    // Botão Cadastrar
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        backgroundColor: Colors.grey[200],
                      ),
                      onPressed: registrarUsuario,
                      child: const Text('Cadastrar', style: TextStyle(color: Color(0xFF105D44))),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        backgroundColor: Colors.grey[200],
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/tela_login'),
                      child: const Text('Voltar', style: TextStyle(color: Color(0xFF105D44))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}