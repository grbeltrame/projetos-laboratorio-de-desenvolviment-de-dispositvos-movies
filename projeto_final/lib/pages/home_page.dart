import 'package:flutter/material.dart';
import '/pages/dashboard_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Não tem necessidade de AppBar nessa pagina
      // O que está faltando:
      //   - implementação do login e cadastro, inteira,
      //   inclusive com a manipulação de banco de dados de acordo com a tabela fornecida no escopo

      backgroundColor: Colors.black87, // Alterado para um preto não tão preto
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Implementar lógica de login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cor do botão de login
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Borda arredondada
                ),
                minimumSize: Size(200, 50), // Tamanho do botão
              ),
              child: Text(
                'Login',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 20.0), // Distância vertical entre os botões
            ElevatedButton(
              onPressed: () {
                // Implementar tela de cadastro
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent, // Cor de fundo transparente
                side: BorderSide(
                    color: Colors.blue), // Cor da borda do botão de cadastro
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Borda arredondada
                ),
                minimumSize: Size(200, 50), // Tamanho do botão
              ),
              child: Text(
                'Cadastrar',
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
