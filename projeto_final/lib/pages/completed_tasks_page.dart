import 'package:flutter/material.dart';

class TarefasConcluidasPage extends StatelessWidget {
  // advinha? falta tudo dnv, so mudei as cores das pagina. Sou humana my friends 💕
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Completed Tasks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black12,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Implementar exibição de tarefas concluídas
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
