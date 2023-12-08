// database_script.dart

class DatabaseScript {
  static const String createUserTable = '''
    CREATE TABLE IF NOT EXISTS user(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR NOT NULL,
      email VARCHAR NOT NULL,
      password VARCHAR NOT NULL
    );
  ''';

  static const String createTaskBoardTable = '''
    CREATE TABLE IF NOT EXISTS task_board(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR NOT NULL,
      color INTEGER NOT NULL
    );
  ''';

  static const String createTaskTable = '''
    CREATE TABLE IF NOT EXISTS task(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      board_id INTEGER NOT NULL,
      title VARCHAR NOT NULL,
      note TEXT NOT NULL,
      date VARCHAR NOT NULL,
      startTime VARCHAR NOT NULL,
      endTime VARCHAR NOT NULL,
      isCompleted INTEGER,
      FOREIGN KEY(user_id) REFERENCES user(id),
      FOREIGN KEY(board_id) REFERENCES task_board(id)
    );
  ''';

  static const List<String> insertTestData = [
    "INSERT INTO user(name, email, password) VALUES('Teste 1', 'teste1@teste', '123456');",
    "INSERT INTO user(name, email, password) VALUES('Teste 2', 'teste2@teste', '123456');",
    "INSERT INTO user(name, email, password) VALUES('Teste 3', 'teste3@teste', '123456');",
    "INSERT INTO user(name, email, password) VALUES('Teste 4', 'teste4@teste', '123456');",
    "INSERT INTO user(name, email, password) VALUES('Teste 5', 'teste5@teste', '123456');",
    "INSERT INTO task_board(name, color) VALUES('Trabalho', 1);",
    "INSERT INTO task_board(name, color) VALUES('Saúde', 2);",
    "INSERT INTO task_board(name, color) VALUES('Estudo', 3);",
    "INSERT INTO task_board(name, color) VALUES('Flutter', 4);",
    "INSERT INTO task_board(name, color) VALUES('Academia', 5);",
    "INSERT INTO task(user_id, board_id, title, note, date, startTime, endTime, isCompleted) VALUES(1, 1, 'Criar Projeto', 'Definir a estrutura do projeto indicando a linguagem de programação e dados necessários.', '2023-12-01', '2024-01-01', '2024-01-02', 0);",
    "INSERT INTO task(user_id, board_id, title, note, date, startTime, endTime, isCompleted) VALUES(1, 2, 'Comprar Frutas', 'Comprar maça, banana e abacaxi.', '2023-12-01', '2024-01-01', '2024-01-02', 0);",
    "INSERT INTO task(user_id, board_id, title, note, date, startTime, endTime, isCompleted) VALUES(2, 3, 'Estudar P2 de Sistemas Operacionais', 'Fazer resumo de Gerência de Memória focando em Paginação.', '2023-12-01', '2024-01-01', '2024-01-02', 0);",
    "INSERT INTO task(user_id, board_id, title, note, date, startTime, endTime, isCompleted) VALUES(3, 4, 'Projeto Planner de Tarefas', 'Organizar tarefas com o grupo e definir a estrutura do projeto.', '2023-12-01', '2023-12-01', '2022-12-20', 0);",
    "INSERT INTO task(user_id, board_id, title, note, date, startTime, endTime, isCompleted) VALUES(3, 5, 'Correr no Campus da UFF', 'Alcançar a meta de 5KM.', '2023-12-01', '2024-01-01', '2024-01-02', 0);",
  ];
}
