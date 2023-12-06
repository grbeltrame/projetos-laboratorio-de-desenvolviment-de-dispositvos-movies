import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Database _db;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  _initializeDatabase() async {
    _db = await _recoverDataBase();
    _save();
    _list();
  }

  _recoverDataBase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "banco.db");
    print("Teste:" + path);
    Database db =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      String sql = """
            CREATE TABLE usuarios( 
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              nome VARCHAR, 
              idade INTEGER
            );""";
      await db.execute(sql);
    });
    return db;
  }

  _save() async {
    Map<String, dynamic> userData = {"nome": "Maria Silva", "idade": 30};
    int id = await _db.insert("usuarios", userData);
    print("Salvo: $id");
  }

  _list() async {
    String sql = "SELECT * FROM usuarios";
    List usuarios = await _db.rawQuery(sql);
    print("usuarios: ${usuarios.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Database")),
      body: Container(
        child: Text("Exemplo"),
      ),
    );
  }
}
