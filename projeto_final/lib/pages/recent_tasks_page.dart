import 'package:flutter/material.dart';

class TarefasRecentesPage extends StatelessWidget {
  //o que falta:
  // tudo kkk, so mudei as cores da pagina
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RecentTasks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black12,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Implementar exibição de tarefas recentes
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
