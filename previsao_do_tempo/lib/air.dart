import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Air extends StatefulWidget {
  final double latitude;
  final double longitude;

  const Air({super.key, required this.latitude, required this.longitude});

  @override
  // ignore: library_private_types_in_public_api
  _AirState createState() => _AirState();
}

class _AirState extends State<Air> {
  Map<String, dynamic>? airQualityData;

  @override
  void initState() {
    super.initState();
    _buscarQualidadeAr();
  }

  Color _getColorForAQI(int aqi) {
    if (aqi == 1) {
      return Colors.green; // Good
    } else if (aqi == 2) {
      return Colors.yellow; // Fair
    } else if (aqi == 3) {
      return Colors.orange; // Moderate
    } else if (aqi == 4) {
      return Colors.red; // Poor
    } else if (aqi == 5) {
      return Colors.purple; // Very Poor
    } else {
      return Colors.black; // Default color
    }
  }

  Future<Map<String, dynamic>> fetchAirQualityData(
      double lat, double lon) async {
    const apiKey = 'd44784d89d733750351e5697021a0d65';
    final url =
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey'; // Substitua pela sua API Key
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar os dados de qualidade do ar');
    }
  }

  Future<void> _buscarQualidadeAr() async {
    try {
      if (widget.latitude != null && widget.longitude != null) {
        final data =
            await fetchAirQualityData(widget.latitude, widget.longitude);
        setState(() {
          airQualityData = data;
        });
      }
    } catch (e) {
      // Trate erros de chamada à API, por exemplo, exibindo uma mensagem de erro na tela.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Qualidade do Ar'),
      ),
      body: airQualityData == null
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Feedback de carregamento
          : airQualityData!.isEmpty
              ? const Center(
                  child: Text('Dados de qualidade do ar não disponíveis'),
                ) // Tratamento de erros
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Índice de Qualidade do Ar:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${airQualityData!['list'][0]['main']['aqi']}',
                        style: TextStyle(
                          fontSize: 24,
                          color: _getColorForAQI(
                              airQualityData!['list'][0]['main']['aqi']),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Componentes da Qualidade do Ar:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          for (var component
                              in airQualityData!['list'][0]['components'].keys)
                            ListTile(
                              title: Text(
                                component,
                                style: TextStyle(fontSize: 16),
                              ),
                              trailing: Text(
                                '${airQualityData!['list'][0]['components'][component]}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
