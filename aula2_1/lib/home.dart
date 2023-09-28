import 'package:flutter/material.dart';
import 'dart:math';

class HomeState extends StatefulWidget {
  const HomeState({super.key});

  @override
  State<HomeState> createState() => _HomeStateState();
}

class _HomeStateState extends State<HomeState> {
  String img = "images/default.png";
  int contEmp = 0;
  int contVit = 0;
  int contDer = 0;
  List<String> jogadas = [
    "images/tesoura.png",
    "images/papel.png",
    "images/pedra.png"
  ];
  String text = "";
  void _play(name) {
    int i = Random().nextInt(jogadas.length);
    img = jogadas[i];

    setState(() {
      if (jogadas[i] == "images/$name.png") {
        text = "Empate!";
        contEmp++;
      } else if (jogadas[i] == "images/tesoura.png" && name == "papel") {
        text = "Você perdeu";
        contDer++;
      } else if (jogadas[i] == "images/tesoura.png" && name == "pedra") {
        text = "Você ganhou";
        contVit++;
      } else if (jogadas[i] == "images/pedra.png" && name == "papel") {
        text = "Você ganhou";
        contVit++;
      } else if (jogadas[i] == "images/pedra.png" && name == "tesoura") {
        text = "Você perdeu";
        contDer++;
      } else if (jogadas[i] == "images/papel.png" && name == "pedra") {
        text = "Você perdeu";
        contDer++;
      } else if (jogadas[i] == "images/papel.png" && name == "tesoura") {
        text = "Você ganhou";
        contVit++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaggold: widget que cobre td o espaço
      appBar: AppBar(title: Text("JokenPo")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            img,
            height: 150,
          ),
          Text("Escolha uma ação:",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Image.asset(
                  "images/tesoura.png",
                  height: 100,
                ),
                onTap: () {
                  _play("tesoura");
                },
              ),
              GestureDetector(
                child: Image.asset(
                  "images/papel.png",
                  height: 100,
                ),
                onTap: () {
                  _play("papel");
                },
              ),
              GestureDetector(
                child: Image.asset(
                  "images/pedra.png",
                  height: 100,
                ),
                onTap: () {
                  _play("pedra");
                },
              )
            ],
          ),
          Text(text,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Empates: $contEmp",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[600]),
              ),
              Text(
                "Derrotas: $contDer",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent[700]),
              ),
              Text(
                "Vitorias: $contVit",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent[700]),
              )
            ],
          )
        ],
      )),
    );
  }
}

// widget que nao muda se mudar a tela, só é desenhado uma vez
// class Home extends StatelessWidget {
//   // const Home({super.key});
  
// }
