import 'package:flutter/material.dart';

class ConfirmacaoScreen extends StatefulWidget {
  const ConfirmacaoScreen({ Key? key }) : super(key: key);

  @override
  _ConfirmacaoScreenState createState() => _ConfirmacaoScreenState();
}

class _ConfirmacaoScreenState extends State<ConfirmacaoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Confirmacao Screen'),
      ),
    );
  }
}