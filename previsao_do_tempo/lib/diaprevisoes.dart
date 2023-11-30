import 'package:flutter/material.dart';

class DiaPrevisoes extends StatelessWidget {
  final List<Widget> previsoes;

  DiaPrevisoes({required this.previsoes, required String data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previsões do Dia'),
      ),
      body: ListView(
        children: previsoes,
      ),
    );
  }
}
