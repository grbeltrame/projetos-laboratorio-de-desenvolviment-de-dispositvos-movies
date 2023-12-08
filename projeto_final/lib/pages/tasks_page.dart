import 'package:flutter/material.dart';

class TarefasPage extends StatelessWidget {
  // o que falta:
  //tudo kkk, so alterei as cores da pagina, ainda n fiz a UI das tarefas e obviamente falta toda a logica de bd
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black12,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Implementar lista de tarefas e opções de manipulação
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
