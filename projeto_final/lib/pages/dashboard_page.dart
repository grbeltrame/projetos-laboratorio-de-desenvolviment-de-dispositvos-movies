import 'package:flutter/material.dart';
import '/pages/tasks_page.dart';
import '/pages/search_page.dart';
import '/pages/recent_tasks_page.dart';
import '/pages/completed_tasks_page.dart';

class DashboardPage extends StatelessWidget {
  // o que falta:
  //1- toda a logica de manipulação de banco de dados referente a criação de novos quadros de forma dinamica,
  //aqui eu colquei um exemplo pra testar a UI do quadro

  //2-navegação de cada quadro para sua tasks_page equivalente

  //3- logica para aquisição das tarefas referentes a cada quadro

  // Lista de exemplo para simular quadros de tarefas, precisa mudar para inserir a logica de aparição dinamica dos quadros de acordo com as tabelas criadas
  final List<TaskBoard> taskBoards = [
    TaskBoard(id: 1, name: 'Trabalho', color: 1),
    TaskBoard(id: 2, name: 'Saúde', color: 2),
    TaskBoard(id: 3, name: 'Estudo', color: 3),
    TaskBoard(id: 4, name: 'Flutter', color: 4),
    TaskBoard(id: 5, name: 'Academia', color: 5),
  ];

  // Mapa de cores em tons pastéis, quando for aplicar a logica de criação dos quadros de forma dinamica,
  // acrescentem mais opções de cores ou forcem o usuario a informar apenas um numero de 1 a 5
  final Map<int, Color> pastelColors = {
    1: Color(0xFFB2DFDB), // Verde
    2: Color(0xFFFFCCBC), // Laranja
    3: Color(0xFFC5E1A5), // Amarelo
    4: Color(0xFFBBDEFB), // Azul
    5: Color(0xFFFFF59D), // Roxo
  };

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
        actions: [
          PopupMenuButton<String>(
            offset: Offset(0, 48),
            color: Colors.grey[800], // Defina a cor desejada para o retângulo
            onSelected: (value) {
              if (value == 'deslogar') {
                // Implementar lógica para deslogar
                Navigator.pop(context); // Voltar para a tela inicial
              } else if (value == 'pesquisar') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PesquisaPage()),
                );
              } else if (value == 'tarefas_recentes') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TarefasRecentesPage()),
                );
              } else if (value == 'tarefas_concluidas') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TarefasConcluidasPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'deslogar',
                child: Text('Deslogar', style: TextStyle(color: Colors.white)),
              ),
              PopupMenuItem<String>(
                value: 'pesquisar',
                child: Text('Pesquisar', style: TextStyle(color: Colors.white)),
              ),
              PopupMenuItem<String>(
                value: 'tarefas_recentes',
                child: Text('Tarefas Recentes',
                    style: TextStyle(color: Colors.white)),
              ),
              PopupMenuItem<String>(
                value: 'tarefas_concluidas',
                child: Text('Tarefas Concluídas',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('MENU', style: TextStyle(color: Colors.white)),
            ),
          ),
          PopupMenuButton<String>(
            offset: Offset(0, 48),
            color: Colors.grey[800], // Defina a cor desejada para o retângulo
            onSelected: (value) {
              // Implementar lógica para adicionar nova tarefa
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'adicionar_quadro',
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text('Adicionar Novo Quadro',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: taskBoards.length,
            itemBuilder: (context, index) {
              return QuadroTarefasWidget(
                taskBoard: taskBoards[index],
                color: pastelColors[taskBoards[index].color]!,
              );
            },
          ),
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}

// Widget para exibir cada quadro de tarefas
class QuadroTarefasWidget extends StatelessWidget {
  final TaskBoard taskBoard;
  final Color color;

  QuadroTarefasWidget({required this.taskBoard, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Implementar lógica para clicar no quadro e ver as tarefas
        print('Clicou no quadro: ${taskBoard.name}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              taskBoard.name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Tarefas: 0',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modelo de dados para um quadro de tarefas
class TaskBoard {
  final int id;
  final String name;
  final int color;

  TaskBoard({required this.id, required this.name, required this.color});
}
