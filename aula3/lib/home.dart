import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeState extends StatefulWidget {
  const HomeState({super.key});

  @override
  State<HomeState> createState() => _HomeState();
}

class _HomeState extends State<HomeState> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool? checkbox1 = false;
  void save() {
    print("Nome: ${nameController.text}");
    print("Idade: ${ageController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Entrada de dados")),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(children: [
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Nome"),
              maxLength: 5,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              style: TextStyle(fontSize: 30, color: Colors.green),
              controller: nameController,
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Idade"),
              maxLength: 5,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              style: TextStyle(fontSize: 30, color: Colors.green),
              controller: ageController,
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Senha"),
              maxLength: 5,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              style: TextStyle(fontSize: 30, color: Colors.green),
              obscureText: true,
              controller: passwordController,
            ),
            CheckboxListTile(
              value: checkbox1,
              title: Text("Churrasco"),
              subtitle: Text("brasileiro"),
              onChanged: (bool? val) {
                checkbox1 = val;
                setState(() {});
              },
            ),
            ElevatedButton(onPressed: save, child: Text("Salvar")),
          ]),
        ));
  }
}
