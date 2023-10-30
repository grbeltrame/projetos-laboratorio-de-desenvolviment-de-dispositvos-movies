import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MemoryCard extends StatefulWidget {
  final dynamic content;
  bool isFaceUp;
  Function() onTap;

  MemoryCard({
    required this.content,
    required this.isFaceUp,
    required this.onTap,
  });

  @override
  _MemoryCardState createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> {
  @override
  Widget build(BuildContext context) {
    Widget cardContent;

    if (widget.content is String) {
      if (widget.content.startsWith("images/")) {
        cardContent = Image.asset(
          widget.content,
          fit: BoxFit.cover,
        );
      } else {
        cardContent = Text(
          widget.content,
          style: TextStyle(fontSize: 30),
        );
      }
    } else if (widget.content is int) {
      cardContent = Text(
        widget.content.toString(),
        style: TextStyle(fontSize: 30),
      );
    } else {
      cardContent =
          Icon(Icons.help_outline, // Ícone de ponto de interrogação "vazado"
              size: 40, // Tamanho do ícone
              color: Colors.blue);
    }

    return Padding(
      padding: const EdgeInsets.all(6.0), // Margem entre cartas
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), // Borda arredondada
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Sombreamento
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 5),
            ),
          ],
          color: widget.isFaceUp
              ? Colors.white
              : Colors.purple[300], // Cor de fundo
        ),
        child: InkWell(
          onTap: () {
            if (!widget.isFaceUp) {
              widget.onTap();
              setState(() {
                widget.isFaceUp =
                    true; // Altera o estado da carta quando clicada.
              });
            }
          },
          child: Container(
            width: 20,
            height: 20,
            key: ValueKey<bool>(widget.isFaceUp),
            child: Center(
              child: widget.isFaceUp
                  ? cardContent
                  : Icon(
                      Icons
                          .help_outline, // Ícone de ponto de interrogação "vazado"
                      size: 40, // Tamanho do ícone
                      color: Colors.lightBlue[100]),
            ),
          ),
        ),
      ),
    );
  }
}
