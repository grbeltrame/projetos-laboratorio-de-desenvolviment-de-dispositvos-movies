import 'package:flutter/material.dart';
import 'dart:math';

class HomeState extends StatefulWidget {
  const HomeState({super.key});

  @override
  State<HomeState> createState() => _HomeStateState();
}

class _HomeStateState extends State<HomeState> {
  List<String> frases = [
    "Vamos aprender  Flutter",
    "Bom dia!",
    "Boa tarde!",
    "Dart é a melhor linguagem!"
  ];

  String text = "Clique abaixo para gerar uma frase:";
  void _play() {
    int i = Random().nextInt(frases.length);
    print("Frase selecionada $i: ${frases[i]}");
    setState(() {
      text = frases[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaggold: widget que cobre td o espaço
      appBar: AppBar(title: Text("Frases Aleatorias")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            "images/title.png",
            height: 200,
          ),
          Text(text,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          ElevatedButton(onPressed: _play, child: Text("Nova frase"))
        ],
      )),
    );
  }
}

// widget que nao muda se mudar a tela, só é desenhado uma vez
// class Home extends StatelessWidget {
//   // const Home({super.key});
  
// }
