import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({ Key? key }) : super(key: key);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Ranking Screen'),
      ),
    );
  }
}