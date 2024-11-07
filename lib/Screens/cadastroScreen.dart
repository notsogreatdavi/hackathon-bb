import 'package:flutter/material.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({ Key? key }) : super(key: key);

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Cadastro Screen'),
      ),
    );
  }
}