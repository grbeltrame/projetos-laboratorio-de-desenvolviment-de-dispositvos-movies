import 'package:app2/diaprevisoes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _cidadeController = TextEditingController();
  List<List<Widget>> previsoesWidgets = List.generate(
      5, (index) => []); // Lista de Listas de Widgets para as previsões
  bool cardsVisiveis =
      false; // Variável para controlar a visibilidade dos cards
  double? latitude; // Coordenada latitude inicializada como nula
  double? longitude; // Coordenada longitude inicializada como nula

  Future<Map<String, dynamic>> fetchGeocodingData(String city) async {
    const apiKey = 'd44784d89d733750351e5697021a0d65';
    final url =
        'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$apiKey'; // Substitua pela sua API Key
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        final Map<String, dynamic> cityData = data[0];
        latitude = cityData['lat'];
        longitude = cityData['lon'];
      }

      return {};
    } else {
      throw Exception('Falha ao carregar os dados de geocoding');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherData(double lat, double lon) async {
    final apiKey = 'd44784d89d733750351e5697021a0d65';
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey';
    // Substitua pela sua API Key
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar os dados de previsão do tempo');
    }
  }

  Future<void> _buscarPrevisaoClima(String cidade) async {
    try {
      await fetchGeocodingData(cidade);
      if (latitude != null && longitude != null) {
        final data = await fetchWeatherData(latitude!, longitude!);
        final previsoes = data['list'];

        if (previsoes != null) {
          previsoesWidgets =
              List.generate(5, (index) => []); // Limpa as listas de previsões

          for (var previsao in previsoes) {
            final dataHora = previsao['dt_txt'];
            final tempMax = previsao['main']['temp_max'];
            final tempMin = previsao['main']['temp_min'];
            const unidadeTemperatura = "Kelvin";
            final situacaoClima = previsao['weather'][0]['description'];
            final icone = previsao['weather'][0]['icon'];

            final iconUrl = 'http://openweathermap.org/img/w/$icone.png';

            // Converte a data para um objeto DateTime
            final DateTime dataPrevisao = DateTime.parse(dataHora);

            // Calcula o índice do dia correspondente (0 a 4)
            final int diaIndex = dataPrevisao.day - DateTime.now().day;

            if (diaIndex >= 0 && diaIndex < 5) {
              previsoesWidgets[diaIndex].add(
                Card(
                  child: Container(
                    color: Colors.blue[50],
                    child: ListTile(
                      leading: Image.network(iconUrl),
                      title: Text('Data/Hora: $dataHora'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Temperatura Máxima: $tempMax $unidadeTemperatura'),
                          Text(
                              'Temperatura Mínima: $tempMin $unidadeTemperatura'),
                          Text('Situação do Clima: $situacaoClima'),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }

          setState(() {
            cardsVisiveis = true; // Torna os cards visíveis
          });
        }
      }
    } catch (e) {
      // Trate erros de chamada à API, por exemplo, exibindo uma mensagem de erro na tela.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Previsão do Tempo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.text,
              controller: _cidadeController,
              decoration: InputDecoration(labelText: 'Digite a cidade'),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              // Utiliza Row para colocar os botões lado a lado
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final cidade = _cidadeController.text;
                      _buscarPrevisaoClima(cidade);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text('Buscar Previsão do Tempo'),
                  ),
                ),
                SizedBox(width: 8), // Adiciona um espaçamento entre os botões
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navegar para a página de qualidade do ar
                      Navigator.pushNamed(context, '/air', arguments: {
                        'latitude': latitude,
                        'longitude': longitude,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text('Qualidade do Ar'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ), // Ajuste o espaçamento entre os botões e os cards
            if (cardsVisiveis)
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime data = DateTime.now().add(Duration(days: index));
                    String dataFormatada =
                        "${data.day}/${data.month}/${data.year}";

                    return Container(
                      margin: EdgeInsets.only(
                          bottom: 8), // Espaçamento entre os cards
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiaPrevisoes(
                                previsoes: previsoesWidgets[index],
                                data: dataFormatada,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Container(
                            color: Colors.blue[50],
                            child: ListTile(
                              title: Text(
                                'Dia $dataFormatada',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
