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
  _recoverDataBase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, "banco.db");
    //await deleteDatabase(path);
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
    Database db = await _recoverDataBase();

    Map<String, dynamic> userData = {"nome": "Maria Silva", "idade": 30};

    int id = await db.insert("usuarios", userData);
    print("Salvo: $id");
  }

  _list() async {
    Database db = await _recoverDataBase();
    //String sql = "SELECT * FROM usuarios";
    //String sql = "SELECT * FROM usuarios WHERE idade = 5";
    //String sql = "SELECT * FROM usuarios WHERE idade >= 30 AND idade <= 58";
    //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 18 AND 46";
    //String sql = "SELECT * FROM usuarios WHERE idade IN(18, 46)";
    //String filter = "an";
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE '%" + filter + "%'";
    //String sql = "SELECT *, UPPER(nome) as nomeUpper FROM usuarios WHERE 1=1 ORDER BY UPPER(nome) DESC ";
    String sql =
        "SELECT *, UPPER(nome) as nomeUpper FROM usuarios WHERE 1=1 ORDER BY idade DESC LIMIT 3";

    List usuarios = await db.rawQuery(sql);

    print("usuarios: ${usuarios.toString()}");
  }

  _getById(int id) async {
    Database db = await _recoverDataBase();
    //CRUD -> Create, Read, Update and Delete
    List usuarios = await db.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ?", whereArgs: [id]);

    print("usuarios: ${usuarios.toString()}");
  }

  _deleteById(int id) async {
    Database db = await _recoverDataBase();
    //CRUD -> Create, Read, Update and Delete
    int response =
        await db.delete("usuarios", where: "id = ?", whereArgs: [id]);

    print("Deleted: $response");
  }

  _updateById(int id) async {
    Database db = await _recoverDataBase();
    //CRUD -> Create, Read, Update and Delete
    Map<String, dynamic> userData = {"nome": "Maria Silva", "idade": 40};

    int response =
        await db.update("usuarios", userData, where: "id = ?", whereArgs: [id]);
    print("Updated: $response");
  }

  @override
  Widget build(BuildContext context) {
    //_save();
    //_list();
    //_deleteById(1);
    _getById(2);
    _updateById(2);

    return Scaffold(
      appBar: AppBar(title: Text("Database")),
      body: Container(
        child: Text("Exemplo"),
      ),
    );
  }
}
