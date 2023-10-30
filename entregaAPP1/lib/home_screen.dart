import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gameoptions.dart';
import 'memory_game.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  bool? imgs = false;
  bool? nums = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(title: Text("Memory Card Game")),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              "images/game_memory.png",
              height: 200,
            ),
            SizedBox(height: 30), // Adicione espaçamento entre os elementos
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Nome"),
              maxLength: 120,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: "San Francisco",
              ),
              controller: nameController,
            ),
            SizedBox(height: 30), // Adicione espaçamento entre os elementos
            CheckboxListTile(
              contentPadding:
                  EdgeInsets.all(0), // Remova a margem interna padrão
              value: imgs,
              title: Text(
                "Imagens",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: "San Francisco",
                ),
              ),
              onChanged: (bool? val) {
                imgs = val;
                setState(() {});
              },
            ),
            CheckboxListTile(
              contentPadding:
                  EdgeInsets.all(0), // Remova a margem interna padrão
              value: nums,
              title: Text(
                "Numeros",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: "San Francisco",
                ),
              ),
              onChanged: (bool? val) {
                nums = val;
                setState(() {});
              },
            ),
            SizedBox(
                height: 50), // Adicione mais espaçamento entre os elementos
            ElevatedButton(
              onPressed: () {
                final gameOptions = GameOptions(
                  nameController.text,
                  imgs ?? false,
                  nums ?? false,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoryGamePage(gameOptions),
                  ),
                );
              },
              child: Text(
                "Iniciar",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
