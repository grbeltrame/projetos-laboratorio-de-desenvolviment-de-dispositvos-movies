import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'memory_card.dart';
import 'gameoptions.dart';

class MemoryGamePage extends StatefulWidget {
  final GameOptions gameOptions;

  MemoryGamePage(this.gameOptions, {Key? key}) : super(key: key);

  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  List<MemoryCard> memoryCards = [];
  List<dynamic> generatedCards = [];
  bool isGameInProgress = false;
  bool isGameOver = false;
  int numberOfTries = 0;
  int secondsRemaining = 20;
  String txt = "";
  late Timer timer;
  int visibleCardCount = 0;
  int userPoints = 0;
  MemoryCard? firstSelectedCard;
  MemoryCard? secondSelectedCard;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  final Set<int> selectedNumbers = Set<int>();

  int generateRandomNumber() {
    final random = Random();
    int number;
    do {
      number = random.nextInt(10); // Gere um número aleatório entre 0 e 9.
    } while (selectedNumbers.contains(number));
    selectedNumbers.add(number); // Marque o número como selecionado.
    return number;
  }

  List<dynamic> createCards(bool numbersSelected, bool imagesSelected) {
    List<dynamic> cards = [];
    int n = 10;
    int m = 5;

    if (imagesSelected && numbersSelected) {
      for (int i = 0; i < m; i++) {
        int x = generateRandomNumber();
        String imgPath = 'images/image_$x.png';
        cards.add(x.toString());
        cards.add(imgPath);
      }
    } else if (numbersSelected) {
      for (int i = 0; i < n; i++) {
        cards.add(i.toString());
      }
    } else if (imagesSelected) {
      for (int i = 0; i < n; i++) {
        String imagePath = 'images/image_$i.png';
        cards.add(imagePath);
      }
    }

    return cards;
  }

  void initializeGame() {
    generatedCards = createCards(
        widget.gameOptions.numbersSelected, widget.gameOptions.imagesSelected);

    List<dynamic> doubledCards = [];
    for (String card in generatedCards) {
      doubledCards.add(card);
      doubledCards.add(card);
    }

    doubledCards.shuffle();

    memoryCards = doubledCards.map((card) {
      return MemoryCard(
        content: card,
        isFaceUp: true,
        onTap: () {
          flipCard(memoryCards.indexOf(card as MemoryCard));
        },
      );
    }).toList();

    isGameInProgress = true;
    numberOfTries = 0;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsRemaining--;
        if (secondsRemaining == 0) {
          timer.cancel();
          for (var card in memoryCards) {
            if (card.isFaceUp) {
              card.isFaceUp = false;
            }
          }
        }
      });
    });
  }

  void flipCard(int index) {
    if (!isGameInProgress || memoryCards[index].isFaceUp) {
      return;
    }

    if (firstSelectedCard == null) {
      firstSelectedCard = memoryCards[index];
      firstSelectedCard!.isFaceUp = true;
    } else if (secondSelectedCard == null) {
      secondSelectedCard = memoryCards[index];
      secondSelectedCard!.isFaceUp = true;
      numberOfTries++;

      if (firstSelectedCard!.content == secondSelectedCard!.content) {
        userPoints += 1;
        firstSelectedCard = null;
        secondSelectedCard = null;
        visibleCardCount += 2;

        if (visibleCardCount == memoryCards.length) {
          isGameInProgress = false;
          setState(() {
            isGameOver = true; // Define o jogo como terminado
          });
          if (numberOfTries > userPoints) {
            txt = "Você pode melhorar, ${widget.gameOptions.playerName}";
          } else if (numberOfTries == userPoints) {
            txt =
                "Parabéns, ${widget.gameOptions.playerName}, você foi muito bem!";
          }
        }
      } else {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            firstSelectedCard!.isFaceUp = false;
            secondSelectedCard!.isFaceUp = false;
            firstSelectedCard = null;
            secondSelectedCard = null;
          });
        });
      }
    }
    setState(() {
      numberOfTries;
      userPoints;
    });
  }

  void restartGame() {
    // Redefina todas as variáveis para um novo jogo
    isGameInProgress = false;
    isGameOver = false;
    numberOfTries = 0;
    secondsRemaining = 20;
    userPoints = 0;
    firstSelectedCard = null;
    secondSelectedCard = null;
    visibleCardCount = 0;
    selectedNumbers.clear(); // Limpa a lista de números selecionados
    initializeGame(); // Inicializa o jogo novamente
    // Reinicie o timer, se necessário
    if (timer.isActive) {
      timer.cancel();
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          secondsRemaining--;
          if (secondsRemaining == 0) {
            timer.cancel();
            for (var card in memoryCards) {
              if (card.isFaceUp) {
                card.isFaceUp = false;
              }
            }
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(title: Text("Memory Card Game")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Tempo restante: $secondsRemaining segundos",
            style: TextStyle(
                fontSize: 16,
                fontFamily: "San Francisco",
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Tentativas: $numberOfTries",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Pontos: $userPoints",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: memoryCards.length,
              itemBuilder: (context, index) {
                final card = memoryCards[index];
                return MemoryCard(
                  content: card.content,
                  isFaceUp: card.isFaceUp,
                  onTap: () {
                    flipCard(index);
                  },
                );
              },
            ),
          ),
          if (isGameOver)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text(
                    txt,
                    style: TextStyle(fontSize: 24),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        restartGame();
                        isGameOver = false;
                      });
                    },
                    child: Text(
                      "Recomeçar",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
