import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _cidadeController = TextEditingController();
  List<Widget> previsoesWidgets = []; // Lista de Widgets para as previsões
  double? latitude; // Coordenada latitude inicializada como nula
  double? longitude; // Coordenada longitude inicializada como nula

  Future<Map<String, dynamic>> fetchGeocodingData(String city) async {
    final apiKey = 'd44784d89d733750351e5697021a0d65';
    final url =
        'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$apiKey'; // Substitua pela sua API Key
    final response = await http.get(Uri.parse(url));

    print('fetchGeocodingData status code: ${response.statusCode}');

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

    print('fetchWeatherData status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      // print("Response body: ${response.body}");

      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar os dados de previsão do tempo');
    }
  }

  Future<void> _buscarPrevisaoClima(String cidade) async {
    print("Chamando funçao de busca");
    try {
      await fetchGeocodingData(cidade);
      print("Rodou Geocoding");
      print('Latitude: $latitude, Longitude: $longitude');
      if (latitude != null && longitude != null) {
        print('Latitude: $latitude, Longitude: $longitude');
        final data = await fetchWeatherData(latitude!, longitude!);
        final previsoes = data['list'];

        if (previsoes != null) {
          previsoesWidgets.clear();

          for (var previsao in previsoes) {
            final dataHora = previsao['dt_txt']; //.substring(0, 10);
            final tempMax = previsao['main']['temp_max'];
            final tempMin = previsao['main']['temp_min'];
            const unidadeTemperatura = "Kelvin";
            final situacaoClima = previsao['weather'][0]['description'];
            final icone = previsao['weather'][0]['icon'];

            // Construa a URL completa para a imagem do ícone do clima
            final iconUrl = 'http://openweathermap.org/img/w/$icone.png';

            previsoesWidgets.add(
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
            print(previsoesWidgets);
          }
          print('Número de widgets de previsões: ${previsoesWidgets.length}');

          setState(() {});
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
                height: 8), // Espaçamento entre o campo de entrada e o botão
            ElevatedButton(
              onPressed: () {
                final cidade = _cidadeController.text;
                print(_cidadeController);
                _buscarPrevisaoClima(cidade);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20), // Ajuste o raio conforme desejado
                ),
                padding: EdgeInsets.all(
                    16), // Ajuste o espaçamento interno conforme desejado
              ),
              child: Text('Buscar Previsão do Tempo'),
            ),
            // Aqui você pode exibir as previsões após a busca.
            Expanded(
              child: ListView.builder(
                itemCount: previsoesWidgets.length,
                itemBuilder: (BuildContext context, int index) {
                  return previsoesWidgets[index];
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar para a página de qualidade do ar
                Navigator.pushNamed(context, '/air', arguments: {
                  'latitude': latitude,
                  'longitude': longitude,
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20), // Ajuste o raio conforme desejado
                ),
                padding: EdgeInsets.all(
                    16), // Ajuste o espaçamento interno conforme desejado
              ),
              child: Text('Qualidade do Ar'),
            ),
          ],
        ),
      ),
    );
  }
}
