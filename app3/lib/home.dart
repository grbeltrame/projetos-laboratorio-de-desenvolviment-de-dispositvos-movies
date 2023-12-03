import 'package:flutter/material.dart';

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palavras Favoritas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<String> _randomWords = ["Flutter", "Dart", "Mobile", "Favorite"];
  late Database _database;

  @override
  void initState() {
    super.initState();
    _recoverDataBase();
  }

  _recoverDataBase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, "favorite.db");
    await deleteDatabase(path);
    print("Teste:" + path);
    Database db =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      String sql = """
            CREATE TABLE favorite( 
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL
            );""";
      await db.execute(sql);
    });

    return db;
  }

  _save() async {
    Database db = await _recoverDataBase();

    String palavraAtual = _randomWords[_generateRandomIndex()];

    Map<String, dynamic> palavraFavorita = {
      "name": palavraAtual,
    };

    int id = await db.insert("favorite", palavraFavorita);
    print("Salvo: $id");

    setState(() {}); // Atualiza a interface para a próxima palavra
  }

  Future<List<Map<String, dynamic>>> _list() async {
    Database db = await _recoverDataBase();
    String sql = "SELECT name FROM favorite";

    return await db.rawQuery(sql);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Palavras Favoritas'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Favoritos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHomeTab(),
            _buildFavoritesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _randomWords[_generateRandomIndex()],
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => {}, //_save(),
              child: Text('Like'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {}),
              child: Text('Next'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _list(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final favorites =
              snapshot.data ?? []; // Adicionei o operador de nulidade
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(favorites[index]['name']),
              );
            },
          );
        }
      },
    );
  }

  int _generateRandomIndex() {
    return DateTime.now().millisecondsSinceEpoch % _randomWords.length;
  }
}
